package handler

import (
	"bytes"
	"fmt"
	"image"
	"image/color"
	"image/png"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/golang/freetype/truetype"
	"golang.org/x/image/font"
	"golang.org/x/image/font/gofont/goregular"
	"golang.org/x/image/math/fixed"
)

func Handler(w http.ResponseWriter, r *http.Request) {
	diffTill := r.FormValue("date")
	today := time.Now()
	diffTillAsDate, err := time.Parse("02/01/2006", diffTill)
	if err != nil {
		http.Error(w, fmt.Errorf("invalid date, failed to parse").Error(), http.StatusInternalServerError)
		return
	}

	distance := today.Sub(diffTillAsDate)

	inYears :=
		(distance.Hours() / (365 * 24))

	text := fmt.Sprintf("%.2f", inYears)

	img := drawImage(text)
	writeImage(w, &img)
}

func drawImage(label string) image.Image {

	ttf, err := truetype.Parse(goregular.TTF)
	if err != nil {
		log.Println(err)
		return nil
	}

	face := truetype.NewFace(ttf, &truetype.Options{
		Size:    14,
		DPI:     72.0,
		Hinting: font.HintingNone,
	})

	m := image.NewRGBA(image.Rect(0, 0, len(label)*11, 13))
	black := color.RGBA{248, 150, 86, 255}
	var img image.Image = m

	x := 4
	y := 12

	point := fixed.Point26_6{X: fixed.Int26_6(x * 64), Y: fixed.Int26_6(y * 64)}

	d := &font.Drawer{
		Dst:  m,
		Src:  image.NewUniform(black),
		Face: face,

		Dot: point,
	}

	d.DrawString(label)
	return img
}

func writeImage(w http.ResponseWriter, img *image.Image) {
	buffer := new(bytes.Buffer)
	if err := png.Encode(buffer, *img); err != nil {
		log.Println("unable to encode image.")
	}

	w.Header().Set("Content-Type", "image/jpeg")
	w.Header().Set("Content-Length", strconv.Itoa(len(buffer.Bytes())))
	if _, err := w.Write(buffer.Bytes()); err != nil {
		log.Println("unable to write image.")
	}
}
