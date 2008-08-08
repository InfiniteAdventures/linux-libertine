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
   2008/08/08 v1.4
   Vorlage fontdoku (License GPL)
   Niedermair]
%
% -----------------------------------------
\listfiles
%
\LoadClass[10pt,a4paper]{scrreprt}
\ProcessOptions\relax
% -----------------------------------------
\setlength{\parindent}{0em}
\setlength{\parskip}{.3\baselineskip}%
\addtolength{\parskip}{\z@ \@plus .3\baselineskip}

\usepackage{textcomp,multicol,xcolor,expdlist,framed,calc,ifthen,substr,array,tabularx}
\newcolumntype{C}{>{\centering\arraybackslash}X}
\usepackage[ngerman]{babel}
%
%
\usepackage{geometry}
\geometry{verbose,a4paper,footskip=1cm,
          top=5mm,bottom=10mm,outer=20mm,inner=20mm,
          includeheadfoot}

%
\usepackage{xcolor,array}
\usepackage[final,writefile]{listings}
%
%\renewcommand{\ttdefault}{pcr}
\lstloadlanguages{java,HTML,[AlLaTeX]TeX,make}
\lstset{extendedchars=true,
        basicstyle=\ttfamily\footnotesize,
        backgroundcolor=\color{lightgray},
        captionpos=b,
        usekeywordsintag=true,
        breaklines=true,
        breakindent=0pt,
        moredelim=[is][\bfseries]{«}{»},
        %prebreak=\Righttorque,
        numbersep=2pt,numbers=none,
        numberstyle=\tiny} % numbers=none / left
%
\renewcommand{\lstlistingname}{Beispiel}
%
\def\charGlyphname#1{\XeTeXglyph\XeTeXglyphindex "#1"}
%----------------------------------------------------------
\endinput