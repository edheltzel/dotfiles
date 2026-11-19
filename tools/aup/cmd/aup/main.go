package main

import (
	"os"

	"github.com/edheltzel/aup/internal/cli"
)

var version = "dev"

func main() {
	os.Exit(cli.Main(version))
}
