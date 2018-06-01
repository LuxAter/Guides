serve:
	mkdocs serve

html:
	mkdocs build

pdf:
	mkdocs2pandoc > styleguides.pd
	pandoc --filter=svg-to-pdf.py -o styleguides.pdf styleguides.pd
	rm styleguides.pd
