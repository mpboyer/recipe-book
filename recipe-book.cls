\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{recipe-book}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions
\PassOptionsToClass{11pt}{book}
\LoadClass{book}

\RequirePackage[T1]{fontenc}
% \RequirePackage[utf8]{inputenc}
\RequirePackage{fontspec}
\setmainfont{Amarante-Regular}[Extension=.ttf]
\RequirePackage{xkeyval}
\RequirePackage{fontawesome5}
\RequirePackage{emoji}

\RequirePackage[a4paper,margin=2cm]{geometry}
\RequirePackage[hidelinks, colorlinks=false]{hyperref}
\RequirePackage{xcolor}
\definecolor{vulm}{HTML}{7d1dd3}
\definecolor{pagecolor}{HTML}{f1f1f1}
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
\RequirePackage{eso-pic}
\RequirePackage{transparent}

\RequirePackage[french]{babel}
\RequirePackage{lettrine}

\addto\captionsfrench{\renewcommand{\contentsname}{\color{black}À Table~!}}

\RequirePackage{enumitem}
\RequirePackage{titlesec}
\titleformat{\section}{\color{vulm}\normalfont\Huge\bfseries}{}{1em}{}
\renewcommand{\thesection}{}

\titleformat{\chapter}[display]
{\normalfont\Huge\color{vulm}\bfseries}{}{0pt}{%
	\vspace*{-40pt}%
	\Huge\bfseries% title font
	\filright%
}[\vspace{1ex}%
	\minitoc
	\vspace{2ex}
]

\setcounter{minitocdepth}{2}
\renewcommand{\mtctitle}{}
\dominitoc

\newcommand*{\recette}[1]%
{%
	\section{#1}
	\index{#1}
}

\RequirePackage{units}
\RequirePackage{tabulary}

\def\textemoji#1{\raisebox{2pt}{\emoji{#1}}}
\def\preptime#1{\textemoji{cook}~Préparation~:~#1}
\def\cooktime#1{\textemoji{cooking}~Cuisson~:~#1}
\def\baketime#1{\textemoji{baguette-bread}~Four~:~#1}
\def\people#1{\textemoji{fork-and-knife-with-plate}~Pour~#1~couverts}
\def\cooltime#1{\textemoji{snowflake}~Frigo~:~#1}
\def\robot#1{\textemoji{robot}~Ustensiles~:~#1}

\def\mn#1{\unit[#1]{mn}}
\def\hr#1{\unit[#1]{h}}
\def\celsius#1{\unit[#1]{°C}}

\def\notempty#1#2{
	\ifx&#1&
	\!
	\else
	#2
	\fi
}


\def\thesep{ | }
\makeatletter
\newcommand{\params}[6]{%
	\noindent
	\def\s@p{}%
	\ifx\relax#1\relax
	\else
		\s@p\people{#1}\def\s@p{\thesep}\fi%
	\ifx\relax#2\relax
	\else
		\s@p\preptime{#2}\def\s@p{\thesep}\fi%
	\ifx\relax#3\relax
	\else
		\s@p\cooktime{#3}\def\s@p{\thesep}\fi%
	\ifx\relax#4\relax
	\else
		\s@p\baketime{#4}\def\s@p{\thesep}\fi%
	\ifx\relax#5\relax
	\else
		\s@p\cooltime{#5}\def\s@p{\thesep}\fi%
	\ifx\relax#6\relax
	\else
		\s@p\robot{#6}\def\s@p{\thesep}\fi%
}
\makeatother


\def\recipe#1#2{%
	\vspace{3em}\noindent
	\begin{minipage}[t]{0.33\textwidth}
		\textbf{Les ingrédients}
		\\[1em]
		\def\arraystretch{1.2}
		\begin{NiceTabular}[width=\linewidth]{X[r, m]X[l, m]}
			#1
		\end{NiceTabular}
	\end{minipage}
	\begin{minipage}[t]{.01\textwidth}

	\end{minipage}
	\begin{minipage}[t]{.66\textwidth}
		\textbf{La recette}
		\begin{enumerate}[label=\color{vulm}\theenumi, font=\bfseries]
			#2
		\end{enumerate}
	\end{minipage}
}

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

\def\info#1{%
	\vfill
	\begin{tikzpicture}[overlay]
		\draw[line width=1.5pt, color=vulm] (-.2, 0) -- (3, 0);
		\draw[line width=1.5pt, color=vulm] (0, .2) -- (0, -1);
	\end{tikzpicture}
	%
	\vspace{1em}
	\hspace{1em}
	\begin{minipage}{.915\textwidth}
		\itshape#1
	\end{minipage}
}

\def\newrecipe#1#2#3#4#5#6#7#8{
	\illus{#2}
	\newpage
	\recette{#1}
	\params{#3}{#4}{#5}{#6}{#7}{#8}
}

\def\therecipe#1#2#3{%
	\recipe{#1}{#2}
	\ifx&#3&
	\vfill
	\else
	\info{#3}
	\fi
}

\def\includeindex{%
	\addcontentsline{toc}{chapter}{Index}
	\printindex
}

\RequirePackage{luacode}
\begin{luacode*}
	dofile("mergefiles.lua")
\end{luacode*}

\AfterBeginDocument{\frontmatter\maketitle\dominitoc\tableofcontents\makeindex\mainmatter}
\AtEndDocument{\backmatter\includeindex}



\newcommand{\inputAllFiles}[1]{%
	\directlua{inputAllFiles("#1")}%
	\InputIfFileExists{Recettes/#1/main.tmp}{}{}
}

