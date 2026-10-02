# posterzine

PosterZine is a LaTeX document class that allows you to create a poster that
can be transformed into a zine.

A 'zine' is a small magazine-like booklet that is made by printing panels
onto a page (usually 8 panels), then cutting and folding the page so that the
panels become the individual pages.

A poster can be anything, of course, but in this case it is intended to be
a poster that is shown at an academic conference; the poster also consists
of panels.

The PosterZine document class allows you to create the individual panels
as a normal LaTeX document. This means that things like equation counters
and other TeX elements will all work as they normally would.

But with PosterZine, you can create the document once, then at layout time, the layout can be
either a poster (with panels all right-side up, starting with panel 1 at the
top left) or a zine. Zines have to be printed with the panels in different
positions, and some of them upside down, so that when the zine is folded
the panels form the front and back cover and internal pages of the booklet.

## Getting started

Downloading the repository into a single directory and running the buildall.sh
script should do the following:

- Build the 'Demo1_Poster.pdf' file, which is built from Demo1_Poster.tex.
- Build the 'Demo1_Zine.pdf' file, which is built from Demo1_Zine.tex.
- Build the 'Demo2_Poster.pdf' file, which is built from Demo2_Poster.tex
- Create a Demo2_Zine.tex file, which is *identical to* the Demo2_Poster.tex file except that it adds the 'zine' document class option
- Build the 'Demo2_Zine.pdf' file, which is built from the (new) Demo2_Zine.tex file

The demos have the following purposes:

- Demo1_Poster.tex shows the basics of adding elements to panels.
- Demo1_Zine.tex is identical to Demo1_Poster.tex, except that the 'zine' option is added. The point of this is to show that the document class has these two different expressions
- Demo1_Poster.pdf and Demo1_Zine.pdf show how the panels are layed out in poster vs. zine format. In poster format, the first panel is at the top left, and the panels go from left to right for C columns, then go downward by rows. In the zine format, the first panel is the bottom right (which will become the front cover). The next panels start at the top left and go right to left, upside down. When the end of the row (left side of the page) is reached, the panels are added to the bottom row, right-side up, left to right, ending in the second-to-last position, which will become the back cover.
- Demo2_Poster.tex demonstrates advanced features, such as making double-width panels (which become facing pages in zine mode) adding multiple elements to a panel, drawing borders around panels, clipping to borders, adding text boxes and images to panels, adding tikz pictures to panels, using normal tex functions like equations and bibtex, using elements from the article class, etc.

## Document class options

The options for the posterzine document class are:

- pwidth: Width of the page as a TeX length (assumed to be in landscape mode); default is 11in
- pheight: Height of the page as a TeX length (assumed to be in landscape mode); default is 8.5in
- phmargin: Horizontal margin as a TeX length; default is 0.5cm
- phspacer: Horizontal spacing between panels as a TeX length; default is 0.5cm
- pvmargin: Vertical margin as a TeX length; default is 0.5cm
- pvspacer: Vertical spacing between panel rows as a TeX length; default is 0.25in
- pcols: Number of columns; default is 4
- prows: Number of rows; default is 2
- zine: Boolean flag; if present, layout is in 'zine' mode (see above), otherwise layout is in 'poster' mode. Default is false

## Notes

Very little checking is done to ensure that the values for the document class options make sense. 4 columns and 2 rows is fine; 7 columns and 157 rows would not work very well. Use responsibly.

The paradigm for creating the poster/zine is to advance through the panels one by one. It is possible to subvert this by setting the \currentpanelcol and \currentpanelrow counters directly, and this may be needed in some cases. (For a quasi-example see the yellow circle in Demo2, which is *not* clipped, so it extends off the top of the page in 'poster' mode, but bleeds into the lower row's panels in 'zine' mode. In cases like this, modifying the order in which panels are drawn might help address the overlap, i.e. if the yellow circle were drawn on top of the lower row's panels, although in this case it is not.) However, making the panels out of order can cause issues with LaTeX's counters, e.g. equations, section numbers, etc.. It may be worth experimenting with putting elements like rows into tikz clipping environments, but this has not been tested.

The example of including graphics via manually using the '\includegraphics' command mainly shows that it doesn't work as expected; commands like 'viewport' do strange things to the scales of the images.

## FAQ

### Does anyone need this?

Probably not.

### Could you use it at a conference, with the poster behind you, handing out 'zine' versions so that people can take them home by simply putting them in their pockets??

Sure.

### Why did you make this?

Because the juxtaposition of LaTex, an environment preferred by the most serious
scientists for its ability to typeset complex equations, with the idea of the kind
of thing a kid might make, made me laugh. But, yes, I will be using it at a conference.

### Is the use of the Carleton et al. paper shameless self-promotion of a paper you coauthored?

Yes. The original is at https://link.springer.com/article/10.1007/s10816-026-09798-w

### Is there a way I can support your work?

Working on it; I'll have a Patreon set up at some point, though 'tech toys' is only one small part of what I do. I'm actually an archaeologist. You can find out more at http://perfectknowledgedb.com
