pdflatex Demo1_Poster.tex; pdflatex Demo1_Poster.tex; rm *.aux; rm *.log
pdflatex Demo1_Zine.tex;   pdflatex Demo1_Zine.tex;   rm *.aux; rm *.log
pdflatex Demo2_Poster.tex; bibtex Demo2_Poster; pdflatex Demo2_Poster.tex; pdflatex Demo2_Poster.tex; rm *.aux; rm *.log; rm *.bbl; rm *.blg

rm Demo2_Zine.tex

echo "\documentclass[pwidth=11.0in,pheight=8.5in,pcols=4, zine]{posterzine}" > Demo2_Zine.tex
tail -n +2 Demo2_Poster.tex >> Demo2_Zine.tex

pdflatex Demo2_Zine.tex;   bibtex Demo2_Zine;   pdflatex Demo2_Zine.tex;  pdflatex Demo2_Zine.tex;     rm *.aux; rm *.log; rm *.bbl; rm *.blg
