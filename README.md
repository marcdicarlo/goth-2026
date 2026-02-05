# goth stack boilerplate

Basic boilerplate for a goth stack app. The goal of this template is to be a starting point for a go base web app using the tailwindcss cli (not npm), templ (https://templ.guide/), basecoat (https://basecoatui.com/), and godoc. The goal of this template is to update this code to work with the lastest binaries/libraries.

## tech stack

- go version go1.25.5 linux/amd64
- tailwindcss v4.1.18
- templ
- HTMX
- basecoat TODO: replace frankenui
- godoc

## commands

``` sh
wget https://github.com/tailwindlabs/tailwindcss/releases/download/v4.1.6/tailwindcss-linux-x64 -o tailwindcss
chmod +x tailwindcss
```

```sh
tailwindcss -i ./static/input.css -o ./static/output.css --watch
```

```sh
templ generate
```

### theme blob

```json
{ "mode":"light", "theme": "uk-theme-slate" }
```

## refferences

[tailwindcss v4 docs](https://tailwindcss.com/docs)

[templ docs](https://templ.guide/)

https://github.com/tailwindlabs/tailwindcss/releases/download/v4.1.6/tailwindcss-linux-x64

https://go.dev/blog/godoc

https://pkg.go.dev/golang.org/x/tools/cmd/godoc