package utils

type ValidationError struct {
	CheckName string
	Severity  int64
	Title     string
}
