%
% Vorlagenklasse 'fontdoku'
%
% (c) EDV-Service Elke Niedermair
%
% (License GPL)
%
% $Id$
%
% -----------------------------------------
\NeedsTeXFormat{LaTeX2e}[2003/12/01]
\ProvidesClass{fontdoku}[%
   2008/08/13 v1.4b
   Vorlage fontdoku (License GPL)
   Niedermair]
%
% -----------------------------------------
\listfiles
%
\LoadClass[10pt,a4paper]{scrartcl}
\ProcessOptions\relax
% -----------------------------------------
\setlength{\parindent}{0em}
\setlength{\parskip}{.3\baselineskip}%
\addtolength{\parskip}{\z@ \@plus .3\baselineskip}

\usepackage{textcomp,multicol,xcolor,expdlist,framed,calc,ifthen,substr,array,tabularx}
\newcolumntype{C}{>{\centering\arraybackslash}X}
\usepackage[ngerman]{babel}
\RequirePackage[obeyspaces,spaces,hyphens]{url}
%
%
\usepackage{geometry}
\geometry{verbose,a4paper,footskip=1cm,
          top=5mm,bottom=10mm,outer=20mm,inner=20mm,
          includeheadfoot}
%
\RequirePackage{scrpage2}
\pagestyle{scrheadings}
%
\usepackage{xcolor,array}
\usepackage[final,writefile]{listings}
\usepackage{lstsample}
%
%\renewcommand{\ttdefault}{pcr}
\lstloadlanguages{java,HTML,[AlLaTeX]TeX,make}
\lstset{extendedchars=true,
        basicstyle=\ttfamily\footnotesize,
        backgroundcolor=\color{lightgray},
        captionpos=b,
        %usekeywordsintag=true,
        breaklines=true,
        breakindent=0pt,
        moredelim=[is][\bfseries]{«}{»},
        %prebreak=\Righttorque,
        numbersep=2pt,numbers=none,
        numberstyle=\tiny} % numbers=none / left
%
\renewcommand{\lstlistingname}{Beispiel}
%
% sauberer Flattersatz
\RequirePackage{ragged2e}
%
%\RequirePackage{makeidx}
\RequirePackage[makeindex]{splitidx}
\newcommand*{\bb}[1]{\textbf{#1}}% index fett
\def\see#1#2{{\reset@font\it\seename\/} #1}
\def\dominator#1{\underline{#1}}
\def\heading#1{{\reset@font\sffamily\Large#1}\hfil\nopagebreak}
\def\indexcolumn{2}
\renewenvironment{theindex}%
               {%
                \columnseprule \z@
                \columnsep 10\p@
                \hyphenpenalty10000
                \exhyphenpenalty10000
                \pretolerance10000
                \RaggedRight
                \libertine
                % -------------------------------------
                \begin{multicols}{\indexcolumn}[\subsection{\indexname}
                   \@mkboth{\indexname}{\indexname}]%
                   \parindent\z@
                   \parskip\z@ \@plus .3\p@\relax
                   \let\item\@idxitem
               }%
               {%
               \end{multicols}
               \clearpage
               }
%
\renewcommand*\@idxitem  {\par\hangindent 1em}
\renewcommand*\subitem     {\par\hangindent 2em \hspace*{1em}}
\renewcommand*\subsubitem  {\par\hangindent 3em \hspace*{2em}}
\makeindex
%
\usepackage[colorlinks,linkcolor=blue]{hyperref}
%
%----------------------------------------------------------
\endinput