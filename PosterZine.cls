\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{posterzine}[2026/09/22 PosterZine class]

\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{kvoptions}
\RequirePackage{xstring}
\RequirePackage{macroswap}

\SetupKeyvalOptions{
  family=PZ,
  prefix=PZ@
}

\DeclareBoolOption[false]{zine}
\DeclareStringOption[11.0in]{pwidth}[11.0in]
\DeclareStringOption[8.5in]{pheight}[8.5in]
\DeclareStringOption[0.5cm]{phmargin}[0.5cm]
\DeclareStringOption[0.5cm]{phspacer}[0.5cm]
\DeclareStringOption[0.5cm]{pvmargin}[0.5cm]
\DeclareStringOption[0.25in]{pvspacer}[0.25in]
\DeclareStringOption[4]{pcols}[4]
\DeclareStringOption[2]{prows}[2]

% This takes the options above and makes macros of them, using the values passed by the call to document class in the final document
\ProcessKeyvalOptions*

% Includes functionality from the article class
\LoadClass{article}

% Sets article class properties based on the options passed
\setlength{\paperwidth}{\PZ@pwidth}
\setlength{\paperheight}{\PZ@pheight}


% Fundamentals
\newcounter{zinecols}          \setcounter{zinecols}{\PZ@pcols} 
\newlength{\zinehmargin}       \setlength{\zinehmargin}{\PZ@phmargin}   % Distance from edge of paper (not text); for now the l and r margins must be the same
\newlength{\zinehspacer}       \setlength{\zinehspacer}{\PZ@phspacer}   % horizontal space between zine columns
\newlength{\zinepanelwidth}
     \pgfmathsetlength{\zinepanelwidth}{ (\paperwidth - (2 * \zinehmargin + (\thezinecols - 1) * \zinehspacer )) / \thezinecols }
 
\newcounter{zinerows}          \setcounter{zinerows}{\PZ@prows} 
\newlength{\zinevmargin}       \setlength{\zinevmargin}{\PZ@pvmargin}   % Distance from the edge of the paper; for now the t and b margins must be the same
\newlength{\zinevspacer}       \setlength{\zinevspacer}{\PZ@pvspacer}   % horizontal space between zine rows
\newlength{\zinepanelheight}
    \pgfmathsetlength{\zinepanelheight}{ (\paperheight - (2 * \zinevmargin + (\thezinerows - 1) * \zinevspacer)) / \thezinerows }

% If you need to position something that crosses panes
\newcommand{\zinemultiwidth}[1]{ #1 * \zinepanelwidth + (#1 -1) * \zinehspacer }


% The x, y, and rotation values are different for 'poster' vs. 'zine' layout

% Calculate the x position based on the row/column position of the panel
\newcommand{\zinepanelX}[2]{
          {\zinehmargin + (#2 - 1) * \zinepanelwidth + (#2 - 1) * \zinehspacer } 
 }

% Calculate the y position based on the row position of the panel
\newcommand{\zinepanelY}[1]{
       \paperheight - \zinevmargin - #1 * \zinepanelheight - #1 * \zinevspacer + \zinevspacer
}

% Calculate the rotation based on the row position of the panel
\newcommand{\zinerotation}[1]{
       \ifodd #1 {0} \else {0} \fi
 }


% Counters to track position
\newcounter{currentpanelcol}      \setcounter{currentpanelcol}{1}
\newcounter{currentpanelrow}      \setcounter{currentpanelrow}{1}

% These commands are different depending on whether the layout is 'poster' or 'zine';
% the starting position (current panel and row) are also adjusted
\ifPZ@zine 
   % Arg 1 = row, Arg 2 = column
   \renewcommand{\zinepanelX}[2]{
       \ifodd #1 
          {\zinehmargin + (\thezinecols - #2 + 1) * \zinepanelwidth + (\thezinecols - #2) * \zinehspacer} 
        \else 
          {\zinehmargin + (#2 - 1) * \zinepanelwidth + (#2 - 1) * \zinehspacer } 
        \fi
    }

  % Calculate the y position based on the row position of the panel
  \renewcommand{\zinepanelY}[1]{
       \ifodd #1 {\paperheight - \zinevmargin} \else{\zinevmargin} \fi
  }
  
  % Calculate the rotation based on the row position of the panel
  % (As a 'zine', odd rows are upside-down
  \renewcommand{\zinerotation}[1]{
       \ifodd #1 {180} \else {0} \fi
   }

  % The first panel in Zine mode is at the bottom right of the page, equivalent
  % to being in the last position of the last row
  \setcounter{currentpanelcol}{\thezinecols}
  \setcounter{currentpanelrow}{\thezinerows}
    
\fi

% Reset the current panel column to the 'next' panel by adding n
% panels. If this moves beyond the number of rows, will move to the
% first column of the next row. (Very little error checking here...)
% Takes one argument, the number of panels to advance; default is one
\newcommand{\NextPanel}[1][1]{
  \addtocounter{currentpanelcol}{#1}
  \ifnum\value{currentpanelcol} > \value{zinecols}
     \setcounter{currentpanelcol}{1}
     \stepcounter{currentpanelrow}
     \ifnum\value{currentpanelrow} > \value{zinerows}
        \setcounter{currentpanelrow}{1}
     \fi
   \fi
}


% Document controls
\newcommand{\BeginPosterZine}{
  \begin{document}
  %\pagecolor{white}
  \begin{tikzpicture}[remember picture, overlay]
   \begin{scope}[shift={(current page.south west)}]
}

\newcommand{\EndPosterZine}{
    \end{scope}
  \end{tikzpicture}
\end{document}
}


% Panel settings

% Box Style is the way elements will be placed at the row/column position.
% Permitted values are all combinations of whether there will be a border
% drawn, whether the thing being placed will be clipped at the border, and
% whether the border/clipping area has rounded or straight corners
% none (or any value other than below) - No box drawn, no clipping
% clipstraight         - Clips to box with straight corners
% cliprounded          - Clips to box with rounded corners
% drawstraight         - Draws a box with straight corners, no clipping
% drawrounded          - Draws a box with rounded corners, no clipping
% drawclipstraight     - Draws a box with straight corners and clips
% drawcliprounded      - Draws a box with rounded corners and clips
%  n.b.: The actual check only determines if the value contains 'clip', 'draw', or 'rounded', 
% so "roundeddraw" will work just like "drawrounded", if you want to be clever
\newcommand{\boxstyle}{none}
\newcommand{\setboxstyle}[1]{\renewcommand{\boxstyle}{#1}}

% The color of the box can be specified
\newcommand{\boxcolor}{black}
\newcommand{\setboxcolor}[1]{\renewcommand{\boxcolor}{#1}}

% TODO: Thickness of the border?

% Text elements
% Text elements are always considered to be anchored at the north west (top left) corner
% and positioned from the bottom left of the panel, such that a y shift of zero
% would position the box with its top right corner at the bottom left corner
% of the panel (clipped off, if the panel is clipping). A y shift fraction of 1 moves it to
% the top left (this is the default).

\newcommand{\textboxfont}{\tiny}
\newcommand{\settextboxfont}[1]{\renewcommand{\textboxfont}{#1}}
\newcommand{\resettextboxfont}{\renewcommand{\textboxfont}{\tiny}}

\newcommand{\textboxfill}{white}
\newcommand{\settextboxfill}[1]{\renewcommand{\textboxfill}{#1}}
\newcommand{\resettextboxfill}{\renewcommand{\textboxfill}{white}}


\newcommand{\textboxwidthfrac}{0.9}
\newcommand{\settextboxwidthfrac}[1]{\renewcommand{\textboxwidthfrac}{#1}}
\newcommand{\resettextboxwidthfrac}{\renewcommand{\textboxwidthfrac}{0.9}}


\newcommand{\txshiftfrac}{0.05}
\newcommand{\settxshiftfrac}[1]{\renewcommand{\txshiftfrac}{#1}}
\newcommand{\resettxshiftfrac}{\renewcommand{\txshiftfrac}{0.05}}

\newcommand{\tyshiftfrac}{0.9}
\newcommand{\settyshiftfrac}[1]{\renewcommand{\tyshiftfrac}{#1}}
\newcommand{\resettyshiftfrac}{\renewcommand{\tyshiftfrac}{0.9}}

\newcommand{\trotate}{0.0}
\newcommand{\settrotate}[1]{\renewcommand{\trotate}{#1}}
\newcommand{\resettrotate}{\renewcommand{\trotate}{0.0}}

% Convenience command to reset all options to their defaults
\newcommand{\resettextboxoptions}{\resettextboxfont \resettxshiftfrac \resettyshiftfrac \resettrotate \resettextboxfill}
\resettextboxoptions

% Graphics settings

% Special settings for when placing graphics;
% these allow the position of the graphic with the panel to be
% adjusted (x, y, and rotation), but also the page
% (if the graphic is multi-page, e.g. a pdf), and the size of
% the box into which the graphic is going to be fit, as well as the
% position around which rotation occurs. These follow the
% graphicx implementation of includegraphics, but they do not
% have all of the flexibility of those commands. (For example,
% graphicx commands are executed in order, so that positioning
% and then rotating is not the same as rotating and positioning;
% the order here is height, width, rotation.)
\newcommand{\gxshiftfrac}{0.5}
\newcommand{\setgxshiftfrac}[1]{\renewcommand{\gxshiftfrac}{#1}}
\newcommand{\resetgxshiftfrac}{\renewcommand{\gxshiftfrac}{0.5}}

\newcommand{\gyshiftfrac}{-0.5}
\newcommand{\setgyshiftfrac}[1]{\renewcommand{\gyshiftfrac}{#1}}
\newcommand{\resetgyshiftfrac}{\renewcommand{\gyshiftfrac}{-0.5}}

\newcommand{\gpage}{1}
\newcommand{\setgpage}[1]{\renewcommand{\gpage}{#1}}
\newcommand{\resetgpage}{\renewcommand{\gpage}{-0.5}}

\newcommand{\gheightfrac}{1}
\newcommand{\setgheightfrac}[1]{\renewcommand{\gheightfrac}{#1}}
\newcommand{\resetgheightfrac}{\renewcommand{\gheightfrac}{1}}

\newcommand{\gwidthfrac}{1}
\newcommand{\setgwidthfrac}[1]{\renewcommand{\gwidthfrac}{#1}}
\newcommand{\resetgwidthfrac}{\renewcommand{\gwidthfrac}{1}}

\newcommand{\grotation}{1}
\newcommand{\setgrotation}[1]{\renewcommand{\grotation}{#1}}
\newcommand{\resetgrotation}{\renewcommand{\grotation}{0}}

\newcommand{\gscale}{1}
\newcommand{\setgscale}[1]{\renewcommand{\gscale}{#1}}
\newcommand{\resetgscale}{\renewcommand{\gscale}{1}}

% Convenience command to reset all options to their defaults
\newcommand{\resetgraphicsoptions}{\resetgxshiftfrac \resetgyshiftfrac \resetgpage \resetgrotation \resetgscale}
\resetgraphicsoptions



% This is the main command that places graphics into locations appropriate
% given the specified values for panel row and column
% The arguments are:
%     Row
%     Column
%     Width (number of columns)
%     What kind of content
%     Input File
%
% The input file can be a graphic (png, pdf); typically this is just an external file.
% But it can also be a .tex input file, which can contain anything that a tikz picture
% could contain.
\newcommand{\posterzinepanel}[5]{

  % Temp variables
  \newlength{\pzptmpPanelWidth}
  \newlength{\pzptmpGraphicWidth}
  \newlength{\pzptmpGraphicHeight}


  \pgfmathsetlength{\pzptmpPanelWidth}{\zinemultiwidth{#3}}
  \pgfmathsetlength{\pzptmpGraphicHeight}{\zinepanelheight * \gheightfrac}

     
  % This uses tikz to establish a point at the 'bottom left' of the panel.
  % Note that if you are in zine mode, the 'bottom left' reflects the
  % rotation of the panel, i.e. it will actually be the top right when the
  % page is printed, and the panel will appear upside down
  \begin{scope}[shift={(\zinepanelX{#1}{#2},\zinepanelY{#1})}, rotate=\zinerotation{#1}]
     \IfSubStr{\boxstyle}{clip}{
       \IfSubStr{\boxstyle}{rounded}{  \clip[rounded corners]  (0.0, 0.0) rectangle (\pzptmpPanelWidth, \zinepanelheight); }
                                    {  \clip                   (0.0, 0.0) rectangle (\pzptmpPanelWidth, \zinepanelheight); }}{}
     \IfSubStr{\boxstyle}{draw}{
       \IfSubStr{\boxstyle}{rounded}{  \draw[color=\boxcolor, rounded corners]  (0.0, 0.0) rectangle (\pzptmpPanelWidth, \zinepanelheight); }
                                    {  \draw[color=\boxcolor]                   (0.0, 0.0) rectangle (\pzptmpPanelWidth, \zinepanelheight); }}{}
                                                     
     % This is basically a switch, but has to be nested if/else statements
     
     % If 'graphic'   
     \IfEq{#4}{graphic}{
       % Graphics are positioned from the top left of the panel in tikz
       \begin{scope}[yshift=\zinepanelheight]
              \node[transform shape, xshift=\gxshiftfrac * \pzptmpPanelWidth, yshift=\gyshiftfrac * \zinepanelheight] 
                  {\includegraphics[page=\gpage, height=\pzptmpGraphicHeight, keepaspectratio, angle=\grotation]{#5}};
       \end{scope}
     } % End 'graphic' true; if there are other styles, switch on them here; for now, there is only one.
     { % If 'text'
       \IfEq{#4}{text}{
          \begin{scope}[xshift=\txshiftfrac * \pzptmpPanelWidth, yshift= \tyshiftfrac * \zinepanelheight]
            \node[transform shape, anchor=north west, font=\textboxfont, text width=\textboxwidthfrac * \pzptmpPanelWidth, fill=\textboxfill, rotate=\trotate, rounded corners] 
                {
                   {#5}
                 };
           \end{scope}
       } % End text 'true'
       { % if 'imported text'
         \IfEq{#4}{importedtext}{
           \begin{scope}[xshift=\txshiftfrac * \pzptmpPanelWidth, yshift= \tyshiftfrac * \zinepanelheight]
             \node[transform shape, anchor=north west, font=\textboxfont, text width=\textboxwidthfrac * \pzptmpPanelWidth, fill=\textboxfill, rotate=\trotate, rounded corners] 
                {
                   \input{#5}
                 };
           \end{scope}
          } % end 'imported text' true
          { % if 'imported'
            \IfEq{#4}{imported}{ % This is imported from a file; note that the temp variables and all graphics and text variables
                                 % are available
                \input{#5}
             } % end 'imported true'
             {
               \IfEq{#4}{importedtikz}{
                 \begin{scope}
                    \begin{scope}[transform shape, xshift=\gxshiftfrac * \pzptmpPanelWidth, yshift=\gyshiftfrac * \zinepanelheight, scale=\gscale, rotate=\grotation]
                      \input{#5}
                    \end{scope}
                  \end{scope}
               } 
               { % verbatim - this just takes the argument - default
                 % As above, the temp variables and all graphics and text variables are available
                {#5}
               } % end 'verbatim' true, which is also 'imported' false
             }
           }  % end 'imported text' false
         } % end 'text' false
      } % end 'graphic' false
     
    \end{scope} % Returns tikz to its previous point of reference
  
  % Clear the temp variables  
  \let\pzptmpPanelWidth\relax
  \let\pzptmpGraphicWidth\relax
  \let\pzptmpGraphicHeight\relax
}


% The following commands occur in groups:
%
%   First, a single generic command that passes through the type of thing being added
%   Next:
%       Graphic element:       The thing passed will be the file name used for an 'includegraphics' call
%       Text element:          The thing passed will be text to be placed in a positioned text box
%       Imported Text element: The thing passed will be the file name used for an 'input' call, which will be placed in a positioned text box
%       Imported element:      The thing passed will be a file name used for an 'input' call
%       Imported Tikz element: The thing passed will be a file name used for an 'input' call; the input file should be a tikz picture
%       Verbatim element:      The thing passed will be included verbatim


% Defines the command to add generic element to the current panel; the required element (arg #2)
% is the file to be read as input; the optional element (arg #1) is the
% width, in panels, to be added (default is one panel, but you can
% add a panel that has a width of more than one. Note that no checking
% is done to ensure that this doesn't go off the end of the row
% or that it is on two facing pages of a zine).
%
% Arguments are:
%    Width in panels (optional; default is 1)
%    What kind of content
%    Input file
\newcommand{\AddElement}[3][1]{
  \posterzinepanel{\value{currentpanelrow}}{\value{currentpanelcol}}{#1}{#2}{#3}
 }


% Graphic Elements
% Note that these are done via an '\includegraphics' call inside a tikz node.
% The code here does not include all of the options available in \includegraphics;
% for full control, use AddTikzElement, and make the tikz element a single node
% that has the \includegraphics call inside it, using all the options you want.

\newcommand{\AddGraphicElement}[2][1]{
  \AddElement[#1]{graphic}{#2}
}

\newcommand{\AddGraphicElementAndAdvance}[2][1]{
  \AddGraphicElement[#1]{#2}
  \NextPanel[#1]
}

% Args: Optional column width, in panels (default = 1); name of file; xshift fraction, y shift fraction
\newcommand{\AddGraphicElementAt}[4][1]{

  % Define temp variables
  \newcommand{\tmpx}{#3}
  \newcommand{\tmpy}{#4}

  % swap values with temp variables
  \macroswap{gxshiftfrac}{tmpx}
  \macroswap{gyshiftfrac}{tmpy}

  \AddGraphicElement[#1]{#2}
    
  % swap values back to restore the values pre-call
  \macroswap{tmpx}{gxshiftfrac}
  \macroswap{tmpy}{gyshiftfrac}
  
  % release temp variables
  \let\tmpx\relax
  \let\tmpy\relax
}

\newcommand{\AddGraphicElementAtAndAdvance}[4][1]{
  \AddGraphicElementAt[#1]{#2}{#3}{#4}
  \NextPanel[#1]
}



% Adding Text Elements; these are placed in a text box. Many of the elements
% to position the text box are reused from the way to position graphic elements,
% even though the internal command is different (it does not use 'include graphics')


\newcommand{\AddTextElement}[2][1]{
  \AddElement[#1]{text}{#2}
}

\newcommand{\AddTextElementAndAdvance}[2][1]{
  \AddTextElement[#1]{#2}
  \NextPanel[#1]
}


% Args: Optional column width (default = 1); name of file; xshift fraction, y shift fraction
\newcommand{\AddTextElementAt}[4][1]{

  % Define temp variables
  \newcommand{\tmpx}{#3}
  \newcommand{\tmpy}{#4}

  % swap values with temp variables
  \macroswap{txshiftfrac}{tmpx}
  \macroswap{tyshiftfrac}{tmpy}

  \AddTextElement[#1]{#2}
    
  % swap values back to restore the values pre-call
  \macroswap{tmpx}{txshiftfrac}
  \macroswap{tmpy}{tyshiftfrac}
  
  % release temp variables
  \let\tmpx\relax
  \let\tmpy\relax
}

\newcommand{\AddTextElementAtAndAdvance}[4][1]{
  \AddTextElementAt[#1]{#2}{#3}{#4}
  \NextPanel[#1]
}



% Imported Text Elements; these are identical to normal text
% elements except that the text should come from an imported file

\newcommand{\AddImportedTextElement}[2][1]{
  \AddElement[#1]{importedtext}{#2}
}

\newcommand{\AddImportedTextElementAndAdvance}[2][1]{
  \AddImportedTextElement[#1]{#2}
  \NextPanel[#1]
}


% Args: Optional column width (default = 1); name of file; xshift fraction, y shift fraction
\newcommand{\AddImportedTextElementAt}[4][1]{

  % Define temp variables
  \newcommand{\tmpx}{#3}
  \newcommand{\tmpy}{#4}

  % swap values with temp variables
  \macroswap{txshiftfrac}{tmpx}
  \macroswap{tyshiftfrac}{tmpy}
  
  % Perform the insertion using the temp values
  \AddImportedTextElement[#1]{#2}
  
  % swap values back to restore the values pre-call
  \macroswap{tmpx}{txshiftfrac}
  \macroswap{tmpy}{tyshiftfrac}
  
  % release temp variables
  \let\tmpx\relax
  \let\tmpy\relax

}

\newcommand{\AddImportedTextElementAtAndAdvance}[4][1]{
  \AddImportedTextElementAt[#1]{#2}{#3}{#4}
  \NextPanel[#1]
}



% Adding Imported Elements; these are just added from an import file

% This command places an element imported from a file on the current panel
\newcommand{\AddImportedElement}[2][1]{
  \AddElement[#1]{imported}{#2}
}

% This command places a final element imported from a file on the current
% panel and advances to the next one
\newcommand{\AddImportedElementAndAdvance}[2][1]{
  \AddImportedElement[#1]{#2}
  \NextPanel[#1]
}


% Imported Tikz elements

\newcommand{\AddImportedTikzElement}[2][1]{
  \AddElement[#1]{importedtikz}{#2}
}

\newcommand{\AddImportedTikzElementAndAdvance}[2][1]{
  \AddImportedTikzElement[#1]{#2}
  \NextPanel[#1]
}

% Args: Optional column width (default = 1); name of file; xshift fraction, y shift fraction
\newcommand{\AddImportedTikzElementAt}[4][1]{

  % Define temp variables
  \newcommand{\tmpx}{#3}
  \newcommand{\tmpy}{#4}

  % swap values with temp variables
  \macroswap{gxshiftfrac}{tmpx}
  \macroswap{gyshiftfrac}{tmpy}

  \AddImportedTikzElement[#1]{#2}
    
  % swap values back to restore the values pre-call
  \macroswap{tmpx}{gxshiftfrac}
  \macroswap{tmpy}{gyshiftfrac}
  
  % release temp variables
  \let\tmpx\relax
  \let\tmpy\relax
}

\newcommand{\AddImportedTikzElementAtAndAdvance}[4][1]{
  \AddImportedTikzElementAt[#1]{#2}{#3}{#4}
  \NextPanel[#1]
}



% Adding Verbatim Elements; these pass the elements to be added
% as arguments instead of as input files

\newcommand{\AddVerbatimElement}[2][1]{
  \AddElement[#1]{verbatim}{#2}
}

\newcommand{\AddVerbatimElementAndAdvance}[2][1]{
  \AddVerbatimElement[#1]{#2}
  \NextPanel[#1]
}


% This is the only actual content; we just want a blank page
\pagestyle{empty}
