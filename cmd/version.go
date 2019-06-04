package cmd

import (
	"fmt"

	"github.com/cloud66-oss/alterant/utils"
	"github.com/spf13/cobra"
)

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Show current version and channel",
	Run:   versionExec,
}

func init() {
	rootCmd.AddCommand(versionCmd)
}

func versionExec(cmd *cobra.Command, args []string) {
	fmt.Printf("%s/%s\n", utils.Channel, utils.Version)
}
