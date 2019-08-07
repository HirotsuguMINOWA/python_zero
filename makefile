INDEX=$(shell ls */README.md | sed 's/README.md/index.html/')
PANDOC_HTMLOPT=--mathjax -t html --template=template
PANDOC_TEXOPT=--highlight-style breezeDark --latex-engine=lualatex -V documentclass=ltjarticle -V geometry:margin=1in 
TARGET=$(INDEX)
ASSIGNMENT=string/assignment.pdf gan/assignment.pdf hello/assignment.pdf


all: $(TARGET) index.html

pdf: $(ASSIGNMENT)

index.md: README.md
	sed 's/README.md/index.html/' $< > $@
	gsed -i 's/assignment.md/assignment.html/' $@

index.html: index.md
	pandoc -s $< -o $@ $(PANDOC_HTMLOPT)
	rm -f index.md 

%/index.md: %/README.md
	gsed '2a [[Up]](../index.html)' $< > $@
	gsed -i '3a [[Repository]](https://github.com/kaityo256/python_zero)\n' $@
	gsed -i 's/assignment.md/assignment.html/' $@ 

%/index.html: %/index.md
	pandoc -s $< -o $@ $(PANDOC_HTMLOPT)

%/assignment.md: %/README.md
	gsed -n '/^#\s.*課題/,$$p' $< > $@

%/assignment.pdf: %/assignment.md
	cd $(dir $@);pandoc $(notdir $<) -s -o $(notdir $@) $(PANDOC_TEXOPT)

clean:
	rm -f $(TARGET) index.html
