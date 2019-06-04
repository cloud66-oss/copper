package cmd

import (
	"fmt"
	"os"

	"github.com/mitchellh/go-homedir"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var rootCmd = &cobra.Command{
	Use:   "copper",
	Short: "Copper is a configuration validator",
	Long: `A simple way to validate configuration files for compliance, best practices and policy enforcement. For more information please
visit https://github.com/cloud66-oss/copper`,
}

var (
	cfgFile string
)

func init() {
	cobra.OnInitialize(initConfig)

	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/copper.yaml)")
}

func initConfig() {
	if cfgFile != "" {
		viper.SetConfigFile(cfgFile)
	} else {
		home, err := homedir.Dir()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		viper.AddConfigPath(home)
		viper.AddConfigPath("/etc/copper")
		viper.SetConfigName("copper")
	}

	_ = viper.ReadInConfig()
}

// Execute runs root
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
