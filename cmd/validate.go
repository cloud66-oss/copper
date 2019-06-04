package cmd

import (
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strings"
	"time"

	"github.com/cloud66-oss/copper/utils"

	"github.com/ghodss/yaml"
	"github.com/gobuffalo/packr/v2"
	"github.com/robertkrimen/otto"
	_ "github.com/robertkrimen/otto/underscore" // this imports underscore into otto
	"github.com/spf13/cobra"
)

var modifyCmd = &cobra.Command{
	Use:   "validate",
	Short: "Run validatin script on the given input",
	Run:   validateExec,
}

var (
	inFile    string
	modFile   string
	timeout   time.Duration
	threshold int64
	box       *packr.Box
)

func init() {
	// get the static box setup
	box = packr.New("libjs", "../libjs")

	modifyCmd.Flags().StringVar(&inFile, "in", "", "input file (could be json or yaml)")
	modifyCmd.Flags().StringVar(&modFile, "validator", "", "validator file (javascript)")
	modifyCmd.Flags().DurationVar(&timeout, "timeout", 100*time.Millisecond, "execution timeout")
	modifyCmd.Flags().Int64Var(&threshold, "threshold", 0, "maximum allowed severity")

	rootCmd.AddCommand(modifyCmd)
}

func validateExec(cmd *cobra.Command, args []string) {
	defer func() {
		if r := recover(); r != nil {
			log.Fatal(r)
		}
	}()

	inputData, err := readInput(inFile)
	if err != nil {
		log.Fatal(err)
	}

	modifier, err := ioutil.ReadFile(modFile)
	if err != nil {
		log.Fatal(err)
	}

	vm, err := setupVM()
	if err != nil {
		logError(err)
	}

	if err = loadJSLib(vm); err != nil {
		logError(err)
	}

	if err = loadGoLib(vm); err != nil {
		logError(err)
	}

	if err = loadGlobals(inputData, vm); err != nil {
		logError(err)
	}

	// compile the modifier
	script, err := vm.Compile(modFile, modifier)
	if err != nil {
		log.Fatal(err)
	}

	// run
	if _, err = vm.Run(script); err != nil {
		logError(err)
	}

	// get the result
	result, err := fetchResult(vm)
	if err != nil {
		logError(err)
	}

	validationErrors := make([]utils.ValidationError, 0)
	for idx := 0; idx < len(result); idx++ {
		item := result[idx]

		if item == nil {
			logError(errors.New("validation error item is nil"))
		}
		if item["severity"] == nil {
			logError(errors.New("severity is nil"))
		}
		if item["title"] == nil {
			logError(errors.New("title is nil"))
		}
		if item["check_name"] == nil {
			logError(errors.New("check name is nil"))
		}

		validationError := utils.ValidationError{
			CheckName: item["check_name"].(string),
			Severity:  item["severity"].(int64),
			Title:     item["title"].(string),
		}

		validationErrors = append(validationErrors, validationError)
	}

	hasFailures := false
	for _, item := range validationErrors {
		if item.Severity > threshold {
			fmt.Printf("Check %s failed with severity %d due to %s\n", item.CheckName, item.Severity, item.Title)
			hasFailures = true
		}
	}

	if hasFailures {
		fmt.Println("Validation failed")
		os.Exit(1)
	} else {
		fmt.Println("Validation successful")
	}
}

func readInput(file string) ([]string, error) {
	var input []byte
	var err error

	var reader io.Reader
	if file == "-" {
		reader = os.Stdin
	} else {
		reader, err = os.Open(file)
		if err != nil {
			return nil, err
		}
	}

	input, err = ioutil.ReadAll(reader)
	if err != nil {
		log.Fatalf("in %s\n", err)
	}

	inputData := make([]string, 0)
	parts := strings.Split(string(input), "---")
	for idx, part := range parts {
		partString := strings.TrimSpace(part)
		if len(partString) == 0 {
			continue
		}

		j, err := yaml.YAMLToJSON([]byte(partString))
		if err != nil {
			return nil, fmt.Errorf("%s in part %d", err, idx)
		}

		// only add items with value
		inputData = append(inputData, string(j))
	}

	return inputData, nil
}

func loadJSLib(vm *otto.Otto) error {
	// load js libs
	libs := box.List()
	sort.Strings(libs)
	for _, libFile := range libs {
		classFile, err := box.FindString(libFile)
		if err != nil {
			return err
		}

		// compile
		class, err := vm.Compile(libFile, classFile)
		if err != nil {
			return err
		}

		// run lib
		_, err = vm.Run(class)
		if err != nil {
			return err
		}
	}

	return nil
}

func loadGoLib(vm *otto.Otto) error {
	return nil
}

func loadGlobals(inputData []string, vm *otto.Otto) error {
	_, err := vm.Object("$$ = [" + strings.Join(inputData, ",") + "]")
	if err != nil {
		return err
	}

	_, err = vm.Object("$$.replace = function(item) { replaceResource($$, item); }")
	if err != nil {
		return err
	}

	_, err = vm.Object("errors = new ValidationError()")
	if err != nil {
		return err
	}

	return nil
}

func logError(err error) {
	if t, ok := err.(*otto.Error); ok {
		log.Fatal(t.String())
	} else {
		log.Fatal(err)
	}
}

func fetchResult(vm *otto.Otto) ([]map[string]interface{}, error) {
	// get the result
	value, err := vm.Get("errors")
	if err != nil {
		logError(err)
	}

	v, err := value.Object().Get("errors")
	if err != nil {
		logError(err)
	}

	if v.Object().Class() != "Array" {
		log.Fatalf("errors is not an array")
	}

	jsArray, err := v.Export()
	if err != nil {
		return nil, err
	}

	result := jsArray.([]map[string]interface{})
	return result, nil
}

func setupVM() (*otto.Otto, error) {
	vm := otto.New()
	vm.Interrupt = make(chan func(), 1)
	go func() {
		time.Sleep(timeout)
		vm.Interrupt <- func() {
			panic(fmt.Sprintf("execution didn't complete within the %s timeout", timeout))
		}
	}()

	return vm, nil
}
