package main

import (
	"strings"
	"time"
)

// Date was added to act as a custom Marshal and Unmarshal solution
// for working with various date formats
// that the posts contain and right now supports the following
// "02-01-2006"
// "2006-01-02"
// "02/01/2006"
// "2/01/2006"
// "2006-01-02 15:04:05"
// "2006-01-02T15:04:05.999999999Z07:00"
type Date struct {
	Time time.Time
}

// UnmarshalYAML - unmarshal the date using the supported formats
func (t *Date) UnmarshalYAML(unmarshal func(interface{}) error) error {

	var buf string
	var tt time.Time
	err := unmarshal(&buf)
	if err != nil {
		return nil
	}

	formatsToCheck := []string{
		"02-01-2006",
		"2006-01-02",
		"02/01/2006",
		"2/01/2006",
		"2006-01-02 15:04:05",
		"2006-01-02T15:04:05.999999999Z07:00",
	}

	for _, format := range formatsToCheck {
		tt, err = time.Parse(format, strings.TrimSpace(buf))
		if err != nil {
			continue
		} else {
			break
		}
	}

	if err != nil {
		return err
	}

	t.Time = tt
	return nil
}

// MarshalYAML - Marshal the date into a standard format
func (t Date) MarshalYAML() (interface{}, error) {
	return t.Time.Format("02-01-2006"), nil
}

// FormattedDate - return a standardised date as string to
// be used into templates
func (t Date) FormattedDate() string {
	return t.Time.Format(time.RFC822)
}
