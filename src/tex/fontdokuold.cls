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
   2009/03/27 v2.0  Vorlage fontdoku (License GPL)  Niedermair]
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

\usepackage[T1]{fontenc}
\usepackage[utf8x]{inputenc}
\usepackage{textcomp,multicol,xcolor,expdlist,framed,calc,ifthen,substr,array,tabularx,pdfpages}
\newcolumntype{C}{>{\centering\arraybackslash}X}
\usepackage[polutonikogreek,xlibycus,ngerman]{babel}
%
\usepackage{geometry}
\geometry{verbose,a4paper,footskip=1cm,
          top=5mm,bottom=10mm,outer=20mm,inner=20mm,
          includeheadfoot}

%
\usepackage{microtype}
\usepackage{xcolor,array}
\usepackage[final,writefile]{listings}
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
\newcommand*\includeIfPdfExists[1]{\IfFileExists{#1.pdf}{\includegraphics[scale=.8]{#1.pdf}\newpage}{}}%
\newcommand*\multiIncludePdfImage[2][50]{%
   \begingroup
     \@temptokena{}%
     \@tempcnta=#1\relax\@tempcntb=\z@
     \loop
       \advance\@tempcntb\@ne
       \edef\@tempa{\the\@temptokena
         \noexpand\includeIfPdfExists{#2\ifnum\@tempcntb<10 00\else\ifnum\@tempcntb<100 0\fi\fi\the\@tempcntb}}%
       \@temptokena\expandafter{\@tempa}%
     \ifnum\@tempcntb<\@tempcnta\repeat
     \edef\x{\endgroup\the\@temptokena}%
   \x
}

%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------
\newcommand{\printFont}[1]{%
\begingroup
  %\myfdentry{T1}{fxl}{m}{n}
  \let\myfdentry=\PrintFontShape%
  \InputIfFileExists{#1.inc}{}{}% RN
\endgroup
}
% {T1}{0e2}{m}{n}
\def\PrintFontShape#1#2#3#4{%
  \begingroup
    \@tempswafalse
    % Testweise Font anfordern, dabei aber keinen Fehler provozieren.
    \def\FONT@INVALID{}%
    \def\@latex@error##1##2{\xdef\FONT@INVALID{XXX}}%
    \usefont{#1}{#2}{#3}{#4}\selectfont%
    \ifx\FONT@INVALID\@empty
      \def\x{\endgroup\@tempswafalse}%
    \else
      \def\x{\endgroup\@tempswatrue}%
    \fi
  \x
  % Existiert der das Geforderte �berhaupt?
  \if@tempswa
  % \normalfont\hrulefill~not exist~\hrulefill
  \else
    %\message{START #1-#2-#3-#4 XX}
    \print@Attr{#3}{#4}\newline%
    \mbox{}\hfill{\usefont{#1}{#2}{#3}{#4}\selectfont%
    Dies ist ein Beispieltext mit Zahlen 1234567890!\quad%
    öäüß ÖÄÜ\quad ff fi fl ffi ffl\quad Hamburg\newline%
    \mbox{}\hfill Am 30.4.1987 saß ich im \glqq{}Caf\'e Hamburg\grqq{} und schlürfte Kaffee für 2,65\,{\texteuro}!
    }\par%
    %\message{END #1-#2-#3-#4 XX}
  \fi
}

\newcommand{\printFontText}[1]{%
\begingroup
  %\myfdentry{T1}{fxl}{m}{n}
  \let\myfdentry=\PrintTextFontShape%
  \InputIfFileExists{#1.inc}{}{}% RN
\endgroup
}
% -----------------------------------------------
% {T1}{0e2}{m}{n}
\def\PrintTextFontShape#1#2#3#4{%
  \begingroup
    \@tempswafalse
    % Testweise Font anfordern, dabei aber keinen Fehler provozieren.
    \def\FONT@INVALID{}%
    \def\@latex@error##1##2{\xdef\FONT@INVALID{XXX}}%
    \usefont{#1}{#2}{#3}{#4}\selectfont%
    \ifx\FONT@INVALID\@empty
      \def\x{\endgroup\@tempswafalse}%
    \else
      \def\x{\endgroup\@tempswatrue}%
    \fi
  \x
  % Existiert der das Geforderte �berhaupt?
  \if@tempswa
    % \normalfont\hrulefill~not exist~\hrulefill
  \else
     \pagebreak[0]
     \minisec{\print@Attr{#3}{#4}}\nopagebreak
    {
    \usefont{#1}{#2}{#3}{#4}\selectfont\FontDemoText
    }
  \fi
}


\newcommand{\printFontTab}[1]{%
\begingroup
  %\myfdentry{T1}{fxl}{m}{n}
  \let\myfdentry=\PrintTableFontShape%
  \InputIfFileExists{#1.inc}{}{}% RN
\endgroup
}
% -----------------------------------------------
% {T1}{0e2}{m}{n}
\def\PrintTableFontShape#1#2#3#4{%
  \begingroup
    \@tempswafalse
    % Testweise Font anfordern, dabei aber keinen Fehler provozieren.
    \def\FONT@INVALID{}%
    \def\@latex@error##1##2{\xdef\FONT@INVALID{XXX}}%
    \usefont{#1}{#2}{#3}{#4}\selectfont%
    \ifx\FONT@INVALID\@empty
      \def\x{\endgroup\@tempswafalse}%
    \else
      \def\x{\endgroup\@tempswatrue}%
    \fi
  \x
  % Existiert der das Geforderte �berhaupt?
  \if@tempswa
    % \normalfont\hrulefill~not exist~\hrulefill
  \else
    \fonttab{#1}{#2}{#3}{#4}
  \fi
}











% ------------------------------------------
\newcommand{\print@Attr}[2]{%
     \ifthenelse{\equal{#1}{m}}{(m) normal}{}%
     \ifthenelse{\equal{#1}{b}}{(b) bold}{}%
     \ifthenelse{\equal{#1}{bx}}{(bx) bold}{}%
     \ifthenelse{\equal{#1}{r}}{(r) regular}{}%
     \ifthenelse{\equal{#1}{c}}{(c) black}{}%
     \ifthenelse{\equal{#1}{k}}{(k) book}{}%
     \ifthenelse{\equal{#1}{me}}{(me) medium}{} -
     \ifthenelse{\equal{#2}{n}}{(n) normal}{}%
     \ifthenelse{\equal{#2}{it}}{(it) italic}{}%
     \ifthenelse{\equal{#2}{sl}}{(sl) slanted}{}%
     \ifthenelse{\equal{#2}{sc}}{(sc) caps}{}%
     \ifthenelse{\equal{#2}{ic}}{(ic) italic caps}{}%
}


% ------------------------------------------
% -----------------------------------------------
% {T1}{0e2}{m}{n}
\def\PrintDigitFontShape#1#2#3#4{%
  \begingroup
    \@tempswafalse
    % Testweise Font anfordern, dabei aber keinen Fehler provozieren.
    \def\FONT@INVALID{}%
    \def\@latex@error##1##2{\xdef\FONT@INVALID{XXX}}%
    \usefont{#1}{#2}{#3}{#4}\selectfont%
    \ifx\FONT@INVALID\@empty
      \def\x{\endgroup\@tempswafalse}%
    \else
      \def\x{\endgroup\@tempswatrue}%
    \fi
  \x
  % Existiert der das Geforderte �berhaupt?
  \if@tempswa
    % \normalfont\hrulefill~not exist~\hrulefill
  \else
     \pagebreak[0]
     \minisec{\print@Attr{#3}{#4}}\nopagebreak
    {
    \usefont{#1}{#2}{#3}{#4}\selectfont%
    \FontDemoNummer
    }
  \fi
}
%


% ------------------------------------------
\newcommand{\LT}[1]{\texttt{#1}}
\newcommand{\bs}{\textbackslash}

% Symbol im entsprechenden Font anzeigen
\newcommand{\fsymbol}[5]{\usefont{#1}{#2}{#3}{#4}\fontsize{14pt}{14pt}\selectfont\strut\symbol{#5}}

\newcounter{myx}
\newcounter{myy}
\newcounter{mye}

\newcommand*{\InitToks}{\@temptokena={}}
\newcommand{\AddToks}[1]{\@temptokena=\expandafter{\the\@temptokena #1}}
\newcommand{\AddToksExp}[1]{%
  \edef\@tempa{#1}\expandafter\AddToks\expandafter{\@tempa}}
\newcommand*{\PrintToks}{\the\@temptokena}

\newcommand{\makeTable}[4]{%
  \begingroup
    %\setlength\extrarowheight{1ex}
    \renewcommand{\arraystretch}{1.25}
    \InitToks
    \AddToks{\begin{tabularx}{\linewidth}{@{}|C|C|C|C|C|C|C|C|@{}}\hline}%
    \setcounter{myy}{0}%
    \whiledo{\value{myy} < 32}{%
      \setcounter{myx}{0}%
      \whiledo{\value{myx} < 8}{%
        \setcounter{mye}{\themyy * 8 + \themyx}%
        \AddToksExp{\noexpand\tiny\strut\themye\hfill\noexpand\fsymbol{#1}{#2}{#3}{#4}{\themye}\hfill\mbox{}}%
        \ifthenelse{\value{myx} < 7}%
          {\AddToks{&}}%
          {\AddToks{\\\hline}}%
        \addtocounter{myx}{1}%
      }\addtocounter{myy}{1}%
    }%
    \AddToks{\end{tabularx}}%
    \setlength\extrarowheight{.35ex}%
    \PrintToks
  \endgroup
}

\newcommand{\fonttab}[4]{
   \setlength\extrarowheight{.5ex}
   \normalfont
   \subsubsection{#1 -- #2 -- #3 -- #4}
   \print@Attr{#3}{#4}

   \makeTable{#1}{#2}{#3}{#4}
   \newpage
}

\usepackage{hyperref}

\newcommand{\FontDemoText}{%
\begin{framed}
Weit hinten, hinter den Wortbergen, fern der Länder Vokalien und Konsonantien leben die Blindtexte. Abgeschieden wohnen Sie in Buchstabhausen an der Küste des Semantik, eines großen Sprachozeans. Ein kleines Büchlein namens Duden fließt durch ihren Ort und versorgt sie mit den nötigen Regelialien. Es ist ein paradiesmatisches Land, in dem einem gebratene Satzteile in den Mund fliegen. Nicht einmal von der allmächtigen Interpunktion werden die Blindtexte beherrscht - ein geradezu unorthographisches Leben.

Eines Tages aber beschloß eine kleine Zeile Blindtext, ihr Name war Lorem Ipsum, hinaus zu gehen in die weite Grammatik. Der große Oxmox riet ihr davon ab, da es dort wimmele von bösen Kommata, wilden Fragezeichen und hinterhältigen Semikoli, doch das Blindtextchen ließ sich nicht beirren. Es packte seine sieben Versalien, schob sich sein Initial in den Gürtel und machte sich auf den Weg.

Als es die ersten Hügel des Kursivgebirges erklommen hatte, warf es einen letzten Blick zurück auf die Skyline seiner Heimatstadt Buchstabhausen, die Headline von Alphabetdorf und die Subline seiner eigenen Straße, der Zeilengasse. Wehmütig lief ihm eine rhetorische Frage über die Wange, dann setzte es seinen Weg fort.
\end{framed}}

\newcommand{\FontDemoNummer}{%
\begin{framed}
.0.1.2.3.4.5.6.7.8.9.\\
0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9\hfill 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9\\
2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9\hfill 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9\\
4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9\hfill 5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9\\
6.0 6.1 6.2 6.3 6.4 6.5 6.6 6.7 6.8 6.9\hfill 7.0 7.1 7.2 7.3 7.4 7.5 7.6 7.7 7.8 7.9\\
8.0 8.1 8.2 8.3 8.4 8.5 8.6 8.7 8.8 8.9\hfill 9.0 9.1 9.2 9.3 9.4 9.5 9.6 9.7 9.8 9.9
\end{framed}
}

\newcommand{\FontDemoBeispiel}[4]{%
{\usefont{#1}{#2}{#3}{#4}\selectfont Die ist ein Text mit Zahlen 1234567890!\quad öäüß ÖÄÜ\quad ff fi fl ffi ffl\quad Hamburg}%
\hfill
\ifthenelse{\equal{#3}{m}}{medium}{}%
\ifthenelse{\equal{#3}{b}}{bold}{}%
\ifthenelse{\equal{#3}{c}}{black}{}%
\ifthenelse{\equal{#3}{k}}{book}{}%
\ifthenelse{\equal{#3}{r}}{regular}{} -
\ifthenelse{\equal{#4}{n}}{normal}{}%
\ifthenelse{\equal{#4}{it}}{italic}{}%
\ifthenelse{\equal{#4}{sl}}{slanted}{}%
\ifthenelse{\equal{#4}{sc}}{caps}{}%
\ifthenelse{\equal{#4}{ic}}{italic caps}{}\par%
}

%----------------------------------------------------------
\endinput