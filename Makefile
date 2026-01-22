all: render

render:
	quarto render --cache-refresh

docxs:
	./scripts/create-docxs.sh
