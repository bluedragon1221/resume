OBJDIR := build
SRCDIR := .

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/resume.html: $(SRCDIR)/resume.json $(SRCDIR)/template.html | $(OBJDIR)
	cat $< | tera -st $(SRCDIR)/template.html > $@

$(OBJDIR)/resume.pdf: $(OBJDIR)/resume.html $(SRCDIR)/resume.json | $(OBJDIR)
	cat $(OBJDIR)/resume.html | weasyprint - $(OBJDIR)/resume.pdf

pdf: $(OBJDIR)/resume.pdf
.PHONY: pdf

web: $(OBJDIR)/resume.html
.PHONY: web
