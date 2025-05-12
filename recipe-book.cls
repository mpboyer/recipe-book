\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{recipe-book}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions
\PassOptionsToClass{11pt}{book}
\LoadClass{book}

\RequirePackage[T1]{fontenc}
% \RequirePackage[utf8]{inputenc}
\RequirePackage{fontspec}
\RequirePackage{ebgaramond}
\setmainfont{Amarante-Regular}[Extension=.ttf]
\RequirePackage{xkeyval}
\RequirePackage{fontawesome5}
\RequirePackage{emoji}

\RequirePackage[a4paper,margin=2cm, left=1.5cm, right=1.5cm]{geometry}
\RequirePackage[hidelinks, colorlinks=false]{hyperref}
\RequirePackage{xcolor}
\definecolor{vulm}{HTML}{7d1dd3}
\definecolor{yulm}{HTML}{ffe500}
\definecolor{offwhite}{HTML}{f9f9f9}
\colorlet{pagecolor}{yulm!2}
\pagecolor{pagecolor}
\RequirePackage{imakeidx}
\RequirePackage{titletoc}
\RequirePackage{minitoc}

\RequirePackage{nicematrix}
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\renewcommand{\chaptermark}[1]{\markboth{\normalsize\bfseries\ #1}{}}
\fancyhf{}
\renewcommand{\headrulewidth}{.5pt}
\fancyfoot[LO]{\bfseries\thepage}
\fancyfoot[RO]{\huge\bfseries\textcolor{vulm}{\chaptermark{\thechapter}}}
\makeatletter
\let\ps@plain\ps@empty
\makeatother

\RequirePackage{graphicx}
\graphicspath{{Images/}}
\RequirePackage{wrapfig}
\RequirePackage{floatrow}
\RequirePackage{tikz}
\usetikzlibrary{shadows, decorations, decorations.pathmorphing, decorations.text, calc,
	patterns, decorations.pathmorphing, decorations.pathreplacing, shapes.geometric, calligraphy}

\RequirePackage{eso-pic}
\RequirePackage{transparent}

\RequirePackage[french]{babel}
\RequirePackage{lettrine}

\addto\captionsfrench{\renewcommand{\contentsname}{\color{black}À Table~!}}
\addto\captionsfrench{\renewcommand{\indexname}{\color{black}Index}}

\RequirePackage{enumitem}
\RequirePackage{titlesec}
\titleformat{\section}{\color{vulm}\normalfont\Huge\bfseries}{}{1em}{}
\renewcommand{\thesection}{}

\titleformat{\chapter}[display]
{\normalfont\Huge\color{vulm}\bfseries}{}{0pt}{%
	\vspace*{-40pt}%
	\Huge\bfseries% title font
	\filright%
}[\vspace{1em}%
	\minitoc
]

\setcounter{minitocdepth}{2}
\renewcommand{\mtctitle}{}
\dominitoc

\def\divider{
	\noindent
	\begin{tikzpicture}[line width=0.4mm]
		% Light, thin horizontal line
		\draw[opacity=0.5] (0,0) -- (\textwidth,0);
	\end{tikzpicture}
	\par
	\vspace{2em}
}

\newcommand*{\recette}[1]%
{%
	\section{#1}
	\index{Recette!#1}
	\divider
}


\usepackage{xparse}
\usepackage{siunitx}
\DeclareSIUnit{\hour}{h}
\DeclareSIUnit{\centiliter}{\centi\liter}
\DeclareSIUnit{\milliliter}{\milli\liter}

\sisetup{mode = text}
\gdef\quant#1#2{\qty{#1}{\csname #2\endcsname}}
\gdef\quantrange#1#2#3{\qtyrange{#1}{#2}{\csname #3\endcsname}}

% Use pgffor to define all units
\usepackage{pgffor}
\foreach \scut/\unit in {
		mn/minute,
		hr/hour,
		celsius/degreeCelsius,
		gr/gram,
		kg/kilogram,
		cL/centiliter,
		mL/milliliter,
		Lit/liter,
		s/second
	}{
		\expandafter\xdef\csname\scut\endcsname##1{\quant{##1}{\unit}}
		\expandafter\xdef\csname\scut range\endcsname##1##2{\quantrange{##1}{##2}{\unit}}
	}

\RequirePackage{tabulary}

\def\textemoji#1{\raisebox{2pt}{\emoji{#1}}\kern1pt}
\def\preptime#1{\textemoji{cook}~Préparation~:~#1}
\def\cooktime#1{\textemoji{cooking}~Cuisson~:~#1}
\def\baketime#1{\textemoji{baguette-bread}~Four~:~#1}
\def\people#1{\raisebox{-1pt}{\textemoji{fork-and-knife-with-plate}}~Pour~#1~couverts}
\def\cooltime#1{\textemoji{snowflake}~Frigo~:~#1}
\def\robot#1{\textemoji{robot}~Ustensiles~:~#1}

\def\notempty#1#2{
	\ifx&#1&
	\!
	\else
	#2
	\fi
}


\def\thesep{\kern1pt | \kern1pt}
\makeatletter
\def\thetitle{\@title}
\def\theauthor{\@author}
%
\newcommand{\params}[6]{%
	\noindent
	\begin{tikzpicture}
		\draw (2.5, -.6) -- (0, -.6) -- (0, .6) -- (2.5, .6);
		\draw[dashed] (2.5, -.6) -- (5, -.6);
		\draw[dashed] (2.5, .6) -- (7.5, .6);
		\node[anchor=west, inner xsep=12pt] (1,0) {%
			\def\s@p{}%
			\ifx\relax#1\relax
			\else
				\s@p\people{#1}\def\s@p{\thesep}
				\index{Pour!#1 personnes}
			\fi%
			\ifx\relax#2\relax
			\else
				\s@p\preptime{#2}\def\s@p{\thesep}
				\index{Temps!Préparation!#2}
			\fi%
			\ifx\relax#3\relax
			\else
				\s@p\cooktime{#3}\def\s@p{\thesep}
				\index{Temps!Cuisson!#3}
			\fi%
			\ifx\relax#4\relax
			\else
				\s@p\baketime{#4}\def\s@p{\thesep}
				\index{Temps!Four!#4}
			\fi%
			\ifx\relax#5\relax
			\else
				\s@p\cooltime{#5}\def\s@p{\thesep}
				\index{Temps!Repos!#5}
			\fi%
			\ifx\relax#6\relax
			\else
				\s@p\robot{#6}\def\s@p{\thesep}
				\index{Ustensiles!#6}
			\fi%
		};
	\end{tikzpicture}
}
\makeatother

\RequirePackage{expl3}
\ExplSyntaxOn
\NewDocumentCommand{\tabletoindex}{m}
{
	\seq_set_split:Nnn \l_tmpa_seq { \\ } { #1 } % split by row
	\seq_map_inline:Nn \l_tmpa_seq
	{
		\__process_table_line:n { ##1 }
	}
}

% Process each row, split by &, and write an \index command
\cs_new_protected:Nn \__process_table_line:n
{
	\tl_if_blank:nTF { #1 } { } % skip blank lines
	{
		\seq_set_split:Nnn \l_tmpb_seq { & } { #1 }
		\index{Ingrédient!\seq_item:Nn \l_tmpb_seq {1}!\seq_item:Nn \l_tmpb_seq {2}}
	}
}
\ExplSyntaxOff


\makeatletter
\def\illusfl@g{0}
\def\setinputillus{\def\illusfl@g{1}}
\def\nosetinputillus{\det\illusfl@g{0}}
\def\includeillus#1{
	\ifnum\illusfl@g=1
	\ifx&#1&
	{\textcolor{pagecolor}{The cake is a lie}}
	\else
	\AddToShipoutPictureFG*{\includegraphics[width=\paperwidth, height=\paperheight]{#1}}
	\fi
	\fi
}
\makeatother

\def\illus#1{%
	\newpage
	\vfill{ \transparent{0} :)}
	\includeillus{#1}
}

\def\MarbledBackground{\AddToShipoutPictureBG*{\put(0,0){\parbox[b][\paperheight]{\paperwidth}{\vfill\centering\includegraphics[width=\paperwidth,height=\paperheight]{title-background.png}\vfill}}}}

\RequirePackage{calligra}

\newcommand{\memeleneTitle}{
	\begin{titlepage}
		\MarbledBackground

		\begin{tikzpicture}[remember picture, overlay]
			\fill[black!70!blue] ($(current page.center) + (0,1cm)$) ellipse (5.3cm and 2.5cm);
			\draw[ultra thick, color=black] ($(current page.center) + (0,1cm)$) ellipse (5.3cm and 2.5cm);
			\draw[thick, color=black] ($(current page.center) + (0,1cm)$) ellipse (5cm and 2.2cm);
			\fill[pagecolor] ($(current page.center) + (0,1cm)$) ellipse (5cm and 2.2cm);  % White fill inside

			\node[align=center, font=\sffamily\bfseries, scale=1.4, text width=8cm]
			at ($(current page.center) + (0,1cm)$) {{\calligra\Huge \thetitle}\\[1em] {\calligra\LARGE\theauthor}};
		\end{tikzpicture}
	\end{titlepage}
}


\RequirePackage[most]{tcolorbox}
\newtcolorbox{memelenebox}{
	enhanced,
	colback = pagecolor,
	boxrule=1.2pt,
	sharp corners,
	boxsep=10pt,
	top=14pt,
	bottom=14pt,
	left=12pt,
	right=12pt,
	before skip=14pt,
	after skip=14pt,
	shadow={1mm}{-1mm}{1mm}{black!30}, % soft shadow
}

\def\recipe#1#2{%
	\begin{memelenebox}
		\noindent
		\begin{minipage}[t]{0.33\textwidth}
			\textbf{Les ingrédients}
			\\[1em]
			\def\arraystretch{1.2}
			\begin{NiceTabular}[width=\linewidth]{X[r, m]X[l, m]}
				#1
			\end{NiceTabular}
			\tabletoindex{#1}
		\end{minipage}
		\begin{minipage}[t]{.01\textwidth}

		\end{minipage}
		\begin{minipage}[t]{.66\textwidth}
			\textbf{La recette}
			\begin{enumerate}[label=\color{vulm}\theenumi, font=\bfseries]
				#2
			\end{enumerate}
		\end{minipage}
	\end{memelenebox}
}

\newdimen\remaining
\newdimen\gap
\gap=3em

\def\chefsnotes{
	\noindent
	\begin{tikzpicture}[remember picture, overlay]
		\pgfmathtruncatemacro{\nlines}{\remaining/\gap -1}
		% Decorative title label
		\node[anchor=west, font=\sffamily\large, draw, thick, sharp corners,
			fill=vulm!50, inner sep=8pt, outer sep=0pt]
		at (0,0) {\ebgaramond \LARGE Les Notes du Chef};

		% \draw[fill=vulm, draw=none] (0, -\gap) rectangle (3pt, -\nlines\gap-2\gap);

		\draw[fill=yulm!10] (0pt, -1\gap) rectangle (\textwidth, -2\gap - \nlines\gap);

		% Line loop
		\foreach \i in {1,...,\nlines} {
				\pgfmathsetlengthmacro{\y}{-\gap -\i*\gap}

				% Dotted line (bigger dots)
				\draw[line width=4pt, dash pattern=on 0pt off 8pt, line cap=round]
				(12pt, \y) -- (\textwidth - 12pt, \y);
			}
	\end{tikzpicture}
}

\newdimen\thresh
\thresh=4cm
\def\info#1{%
	\remaining=\dimexpr\pagegoal-\pagetotal\relax
	\advance \remaining by -5em
	\vspace{1em}
	\ifx&#1&
	\ifdim\remaining>\thresh
		\chefsnotes
	\else
	\fi
	\else
	\sbox0{%
		\begin{tikzpicture}
			\node[inner sep=1em, anchor=west, text width=.915\textwidth, minimum width=.915\textwidth, draw=none] (content) {
				\itshape #1
			};

			\draw[line width=1.5pt, color=vulm]
			($(content.north west) + (-0.2, 0)$) --  +(3.2, 0);

			\draw[line width=1.5pt, color=vulm]
			($(content.north west) + (0, 0.2)$) -- ($(content.south west) + (0, -0.2)$);
		\end{tikzpicture}
	}
	\advance \remaining by -\ht0
	\ifdim\remaining>\thresh
		\chefsnotes
		\advance \remaining by 2em
		\vspace{\remaining}
	\else
	\fi
	\par
	\noindent\box0
	\fi
}

\def\newrecipe#1#2#3#4#5#6#7{
	\newpage
	\recette{#1}
	\params{#2}{#3}{#4}{#5}{#6}{#7}
}

\def\therecipe#1#2#3{%
	\recipe{#1}{#2}
	\info{#3}
}

\def\includeindex{%
	\addcontentsline{toc}{chapter}{Index}
	\printindex
}

\RequirePackage{luacode}
\begin{luacode*}
	dofile("mergefiles.lua")
\end{luacode*}

\AfterBeginDocument{\frontmatter\memeleneTitle\dominitoc\tableofcontents\makeindex\mainmatter}
\AtEndDocument{\backmatter\includeindex}



\newcommand{\inputAllFiles}[1]{%
	\directlua{inputAllFiles("#1")}%
	\InputIfFileExists{Recettes/#1/main.tmp}{}{}%
	% \directlua{cleanupTempFile("#1")}%
}

