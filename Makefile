build:
	mkdir -p build

build/resume.pdf: resume.html resume.json | build
	cat resume.json | tera -st resume.html | weasyprint - build/resume.pdf
