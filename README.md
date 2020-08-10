piecepackr: Board Game Graphics
===============================

[![CRAN Status Badge](https://www.r-pkg.org/badges/version/piecepackr)](https://cran.r-project.org/package=piecepackr)

[![Build Status](https://travis-ci.org/piecepackr/piecepackr.png?branch=master)](https://travis-ci.org/piecepackr/piecepackr)

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/piecepackr/piecepackr?branch=master&svg=true)](https://ci.appveyor.com/project/piecepackr/piecepackr)

[![Coverage Status](https://img.shields.io/codecov/c/github/piecepackr/piecepackr/master.svg)](https://codecov.io/github/piecepackr/piecepackr?branch=master)

[![Project Status: Active -- The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

::: {.contents}
:::

`piecepackr` is an [R](https://www.r-project.org/) package designed to
make configurable board game graphics. It can be used with the
[grid](https://www.rdocumentation.org/packages/grid),
[rayrender](https://www.rayrender.net/), and
[rgl](https://www.rdocumentation.org/packages/rgl) graphics packages to
make board game diagrams, board game animations, and custom [Print &
Play
layouts](https://trevorldavis.com/piecepackr/pages/print-and-play-pdfs.html).
By default it is configured to make [piecepack](#piecepack) game
diagrams, animations, and \"Print & Play\" layouts but can be configured
to make graphics for other board game systems as well.

API Intro
---------

### grid.piece

`grid.piece` is the core function that can used to draw board game
components (by default [piecepack](#piecepack) game components) using
[grid](https://www.rdocumentation.org/packages/grid):

``` {.r}
library("piecepackr")
g.p <- function(...) { grid.piece(..., default.units="in") }
g.p("tile_back", x=0.5+c(3,1,3,1), y=0.5+c(3,3,1,1))
g.p("tile_back", x=0.5+3, y=0.5+1)
g.p("tile_back", x=0.5+3, y=0.5+1)
g.p("die_face", suit=3, rank=5, x=1, y=1)
g.p("pawn_face", x=1, y=4, angle=90)
g.p("coin_back", x=3, y=4, angle=180)
g.p("coin_back", suit=4, x=3, y=4, angle=180)
g.p("coin_back", suit=2, x=3, y=1, angle=90)
```

![Piecepack diagram with default
configuration](man/figures/README-intro1-1.png)

### configuration lists

One can use [lists to
configure](https://trevorldavis.com/piecepackr/configuration-lists.html)
the appearance of the game components drawn by `grid.piece`:

``` {.r}
dark_colorscheme <- list(suit_color="darkred,black,darkgreen,darkblue,black",
                     invert_colors.suited=TRUE, border_color="black", border_lex=2)
piecepack_suits <- list(suit_text="\U0001f31e,\U0001f31c,\U0001f451,\u269c,\uaa5c", # 🌞,🌜,👑,⚜,꩜
                    suit_fontfamily="Noto Emoji,Noto Sans Symbols2,Noto Emoji,Noto Sans Symbols,Noto Sans Cham",
                    suit_cex="0.6,0.7,0.75,0.9,0.9")
traditional_ranks <- list(use_suit_as_ace=TRUE, rank_text=",a,2,3,4,5")
cfg <- c(piecepack_suits, dark_colorscheme, traditional_ranks)
g.p <- function(...) { grid.piece(..., default.units="in", cfg=pp_cfg(cfg)) }
g.p("tile_back", x=0.5+c(3,1,3,1), y=0.5+c(3,3,1,1))
g.p("tile_back", x=0.5+3, y=0.5+1)
g.p("tile_back", x=0.5+3, y=0.5+1)
g.p("die_face", suit=3, rank=5, x=1, y=1)
g.p("pawn_face", x=1, y=4, angle=90)
g.p("coin_back", x=3, y=4, angle=180)
g.p("coin_back", suit=4, x=3, y=4, angle=180)
g.p("coin_back", suit=2, x=3, y=1, angle=90)
```

![Piecepack diagram with custom
configuration](man/figures/README-config-1.png)

### oblique 3D projection

`grid.piece` even has some support for drawing 3D diagrams with an
[oblique
projection](https://trevorldavis.com/piecepackr/3d-projections.html):

``` {.r}
cfg3d <- list(width.pawn=0.75, height.pawn=0.75, depth.pawn=1, 
                   dm_text.pawn="", shape.pawn="convex6", invert_colors.pawn=TRUE,
                   edge_color.coin="tan", edge_color.tile="tan")
cfg <- pp_cfg(c(cfg, cfg3d))
g.p <- function(...) { 
    grid.piece(..., op_scale=0.5, op_angle=45, cfg=cfg, default.units="in") 
}
g.p("tile_back", x=0.5+c(3,1,3,1), y=0.5+c(3,3,1,1))
g.p("tile_back", x=0.5+3, y=0.5+1, z=1/4+1/8)
g.p("tile_back", x=0.5+3, y=0.5+1, z=2/4+1/8)
g.p("die_face", suit=3, rank=5, x=1, y=1, z=1/4+1/4)
g.p("pawn_face", x=1, y=4, z=1/4+1/2, angle=90)
g.p("coin_back", x=3, y=4, z=1/4+1/16, angle=180)
g.p("coin_back", suit=4, x=3, y=4, z=1/4+1/8+1/16, angle=180)
g.p("coin_back", suit=2, x=3, y=1, z=3/4+1/8, angle=90)
```

![Piecepack diagram in an oblique
projection](man/figures/README-proj-1.png)

### save\_print\_and\_play and save\_piece\_images

`save_print_and_play` makes a \"Print & Play\" pdf of a configured
piecepack, `save_piece_images` makes individual images of each piecepack
component:

``` {.r}
save_print_and_play(cfg, "my_piecepack.pdf", size="letter")
save_piece_images(cfg)
```

### pmap\_piece

If you are comfortable using R data frames there is also `pmap_piece`
that processes data frame input. It accepts an optional `trans` argument
for a function to pre-process the data frames, in particular if desiring
to draw a 3D [oblique
projection](https://trevorldavis.com/piecepackr/3d-projections.html) one
can use the function `op_transform` to guess both the pieces\'
z-coordinates and an appropriate re-ordering of the data frame given the
desired angle of the oblique projection.

``` {.r}
library("dplyr", warn.conflicts=FALSE)
library("tibble")
df_tiles <- tibble(piece_side="tile_back", x=0.5+c(3,1,3,1,1,1), y=0.5+c(3,3,1,1,1,1))
df_coins <- tibble(piece_side="coin_back", x=rep(1:4, 4), y=rep(c(4,1), each=8),
                       suit=1:16%%2+rep(c(1,3), each=8),
                       angle=rep(c(180,0), each=8))
df <- bind_rows(df_tiles, df_coins)
cfg <- game_systems("dejavu")$piecepack
pmap_piece(df, cfg=cfg, default.units="in", trans=op_transform, op_scale=0.5, op_angle=135)
```

![\'pmap\_piece\' lets you use data frames as
input](man/figures/README-pmap-1.png)

### piece3d (rgl)

`piece3d` draws pieces using `rgl` graphics.

``` {.r}
library("ppgames")
library("rgl")
invisible(rgl::open3d())
rgl::view3d(phi=-30, zoom = 0.8)

df <- ppgames::df_four_field_kono()
envir <- game_systems("dejavu3d")
pmap_piece(df, piece3d, trans=op_transform, envir = envir, scale = 0.98, res = 150)
```

![rgl render](man/figures/README-rgl_snapshot.png)

### piece (rayrender)

`piece` creates `rayrender` objects.

``` {.r}
library("ppgames")
library("rayrender")
df <- ppgames::df_four_field_kono()
envir <- game_systems("dejavu3d")
l <- pmap_piece(df, piece, trans=op_transform, envir = envir, scale = 0.98, res = 150)
scene <- Reduce(rayrender::add_object, l)
rayrender::render_scene(scene, lookat = c(2.5, 2.5, 0), lookfrom = c(0, -2, 13))
```

![3D render with rayrender package](man/figures/README-rayrender-1.png)

### Further documentation

A slightly longer [intro to piecepackr\'s
API](https://trevorldavis.com/piecepackr/intro-to-piecepackrs-api.html)
plus several [piecepackr
demos](https://trevorldavis.com/piecepackr/category/demos.html) and
other [piecpackr
docs](https://trevorldavis.com/piecepackr/category/docs.html) are
available at piecepackr\'s [companion
website](https://trevorldavis.com/piecepackr/) as well as some
pre-configured [Print & Play
PDFs](https://trevorldavis.com/piecepackr/pages/print-and-play-pdfs.html).
More API documentation is also available in the package\'s built-in [man
pages](https://trevorldavis.com/R/piecepackr/reference/index.html).

Game Systems
------------

The function `game_systems` returns configurations for multiple public
domain game systems.

### Checkers

`game_systems` returns a `checkers1` and `checkers2` configuration which
has checkered and lined \"boards\" with matching checker \"bits\" in
various sizes and colors.

``` {.r}
df_board <- tibble(piece_side = "board_face", suit = 3, rank = 8,
               x = 4.5, y = 4.5)
df_w <- tibble(piece_side = "bit_face", suit = 6, rank = 1,
               x = rep(1:8, 2), y = rep(1:2, each=8))
df_b <- tibble(piece_side = "bit_face", suit = 1, rank = 1,
               x = rep(1:8, 2), y = rep(7:8, each=8))
df <- rbind(df_board, df_w, df_b)
df$cfg <- "checkers1"
pmap_piece(df, envir=game_systems(), default.units="in", trans=op_transform, op_scale=0.5)
```

![Starting position for Dan Troyka\'s abstract game
\"Breakthrough\"](man/figures/README-breakthrough-1.png)

### Traditional 6-sided dice

`game_systems` returns a `dice` configuration which can make standard
6-sided dice in six colors.

### Double-12 dominoes

`game_systems` returns seven different configurations for double-12
dominoes:

1)  `dominoes`
2)  `dominoes_black`
3)  `dominoes_blue`
4)  `dominoes_green`
5)  `dominoes_red`
6)  `dominoes_white` (identical to `dominoes`)
7)  `dominoes_yellow`

``` {.r}
library("tibble")

envir <- game_systems("dejavu")

df_dominoes <- tibble(piece_side = "tile_face", x=rep(4:1, 3), y=rep(2*3:1, each=4), suit=1:12, rank=1:12+1,
                      cfg = paste0("dominoes_", rep(c("black", "red", "green", "blue", "yellow", "white"), 2)))
df_tiles <- tibble(piece_side = "tile_back", x=5.5, y=c(2,4,6), suit=1:3, rank=1:3, cfg="piecepack")
df_dice <- tibble(piece_side = "die_face", x=6, y=0.5+1:6, suit=1:6, rank=1:6, cfg="dice")
df_coins1 <- tibble(piece_side = "coin_back", x=5, y=0.5+1:4, suit=1:4, rank=1:4, cfg="piecepack")
df_coins2 <- tibble(piece_side = "coin_face", x=5, y=0.5+5:6, suit=1:2, rank=1:2, cfg="piecepack")
df <- rbind(df_dominoes, df_tiles, df_dice, df_coins1, df_coins2)

pmap_piece(df, default.units="in", envir=envir, op_scale=0.5, trans=op_transform)
```

![Double-12 dominoes and standard dice in a variety of
colors](man/figures/README-dominoes-1.png)

### Piecepack

`game_systems` returns three different [piecepack](#piecepack)
configurations:

1)  `piecepack`
2)  `playing_cards_expansion`
3)  `dual_piecepacks_expansion`

Plus a configuration for a `subpack` aka \"mini\" piecepack and a
`hexpack` configuration.

The piecepack configurations also contain common piecepack accessories
like piecepack pyramids, piecepack matchsticks, and piecepack saucers.

### Looney Pyramids

Configurations for the proprietary Looney Pyramids aka Icehouse Pieces
game system by Andrew Looney can be found in the companion R package
`piecenikr`: <https://github.com/piecepackr/piecenikr>

### Tak Example

Here we\'ll show an example of configuring piecepackr to draw diagrams
for the abstract board game
[Tak](https://en.wikipedia.org/wiki/Tak_(game)) (designed by James
Ernest and Patrick Rothfuss).

Since one often plays Tak on differently sized boards one common Tak
board design is to have boards made with colored cells arranged in rings
from the center plus extra symbols in rings placed at the points so it
is easy to see smaller sub-boards. To start we\'ll write a function to
draw the Tak board.

``` {.r}
library("grid")
library("piecepackr")
grobTakBoard <- function(...) {
    g <- "darkgreen"
    w <- "grey"
    fill <- c(rep(g, 5),
              rep(c(g, rep(w, 3), g),3),
              rep(g, 5))
    inner <- rectGrob(x = rep(1:5, 5), y = rep(5:1, each=5),
                 width=1, height=1, default.units="in", 
                 gp=gpar(col="gold", fill=fill, lwd=3))
    outer <- rectGrob(gp=gpar(col="black", fill="grey", gp=gpar(lex=2)))
    circles <- circleGrob(x=0.5+rep(1:4, 4), y=0.5+rep(4:1, each=4), r=0.1, 
                         gp=gpar(col=NA, fill="gold"), default.units="in")
    rects <- rectGrob(x=0.5+c(0:5, rep(c(0,5), 4), 0:5), 
                      y=0.5+c(rep(5,6), rep(c(4:1), each=2), rep(0, 6)),
                      width=0.2, height=0.2,
                      gp=gpar(col=NA, fill="orange"), default.units="in")
    grobTree(outer, inner, circles, rects)
}
```

Then we\'ll configure a Tak set and write some helper functions to draw
Tak pieces with it.

``` {.r}
cfg <- pp_cfg(list(suit_text=",,,", suit_color="white,tan4,", invert_colors=TRUE,
            ps_text="", dm_text="",
            width.board=6, height.board=6, depth.board=1/4,
            grob_fn.board=grobTakBoard,
            width.r1.bit=0.6, height.r1.bit=0.6, depth.r1.bit=1/4, shape.r1.bit="rect",
            width.r2.bit=0.6, height.r2.bit=1/4, depth.r2.bit=0.6, shape.r2.bit="rect", 
            width.pawn=0.5, height.pawn=0.5, depth.pawn=0.8, shape.pawn="circle",
            edge_color="white,tan4", border_lex=2,
            edge_color.board="tan", border_color.board="black"))
g.p <- function(...) { 
    grid.piece(..., op_scale=0.7, op_angle=45, cfg=cfg, default.units="in")
}
draw_tak_board <- function(x, y) { 
    g.p("board_back", x=x+0.5, y=y+0.5) 
}
draw_flat_stone <- function(x, y, suit=1) { 
    z <- 1/4*seq(along=suit)+1/8
    g.p("bit_back", x=x+0.5, y=y+0.5, z=z, suit=suit, rank=1)
}
draw_standing_stone <- function(x, y, suit=1, n_beneath=0, angle=0) {
    z <- (n_beneath+1)*1/4+0.3
    g.p("bit_back", x=x+0.5, y=y+0.5, z=z, suit=suit, rank=2, angle=angle)
}
draw_capstone <- function(x, y, suit=1, n_beneath=0) {
    z <- (n_beneath+1)*1/4+0.4
    g.p("pawn_back", x=x+0.5, y=y+0.5, z=z, suit=suit)
}
```

Then we\'ll draw an example Tak game diagram:

``` {.r}
pushViewport(viewport(width=inch(6), height=inch(6)))
draw_tak_board(3, 3)
draw_flat_stone(1, 1, 1)
draw_flat_stone(1, 2, 2)
draw_flat_stone(2, 4, 1)
draw_capstone(2, 4, 2, n_beneath=1)
draw_flat_stone(2, 5, 2)
draw_flat_stone(3, 4, 1:2)
draw_flat_stone(3, 3, c(2,1,1,2))
draw_flat_stone(3, 2, 1:2)
draw_flat_stone(3, 1, 2)
draw_standing_stone(4, 2, 2, angle=90)
draw_flat_stone(5, 2, 1)
draw_capstone(5, 3, 1)
popViewport()
```

![Tak game diagram](man/figures/README-diagram-1.png)

Installation
------------

To install the last version released on CRAN use the following command
in [R](https://www.r-project.org/):

``` {.r}
install.packages("piecepackr")
```

To install the development version use the following commands:

``` {.r}
install.packages("remotes")
remotes::install_github("piecepackr/piecepackr")
```

The default piecepackr configuration should work out on the box on most
modern OSes including Windows without the user needing to mess with
their system fonts. However if you wish to use advanced piecepackr
configurations you\'ll need to install additional Unicode fonts and
Windows users are highly recommended to use and install piecepackr on
\"Ubuntu on Bash on Windows\" if planning on using Unicode symbols from
multiple fonts. The following bash commands will give you a good
selection of fonts (Noto, Quivira, and Dejavu) on Ubuntu:

``` {.bash}
sudo apt install fonts-dejavu fonts-noto 
fonts_dir=${XDG_DATA_HOME:="$HOME/.local/share"}/fonts
curl -O http://www.quivira-font.com/files/Quivira.otf
mv Quivira.otf $fonts_dir/
curl -O https://noto-website-2.storage.googleapis.com/pkgs/NotoEmoji-unhinted.zip
unzip NotoEmoji-unhinted.zip NotoEmoji-Regular.ttf
mv NotoEmoji-Regular.ttf $fonts_dir/
rm NotoEmoji-unhinted.zip
```

**Note** `piecpackr` works best if the version of R installed was
compiled with support for Cairo and fortunately this is typically the
case. One can confirm if this is true via R\'s `capabilities` function:

``` {.r}
> capabilities("cairo")
cairo
 TRUE
```

Also although most users won\'t need them `piecpackr` contains utility
functions that depend on the system dependencies `ghostscript` and
`poppler-utils`:

1.  `save_print_and_play` will embed additional metadata into the pdf if
    `ghostscript` is available.
2.  `get_embedded_font` (a debugging helper function) needs `pdffonts`
    (usually found in `poppler-utils`)

You can install these utilities on Ubuntu with

``` {.bash}
sudo apt install ghostscript poppler-utils
```

Frequently Asked Questions
--------------------------

### What is the package licence?

This software package is released under a [Creative Commons
Attribution-ShareAlike 4.0 International license (CC BY-SA
4.0)](https://creativecommons.org/licenses/by-sa/4.0/). This license is
compatible with version 3 of the GNU Public License (GPL-3).

### How should I Print & Play my piecepack?

The Print-and-Play pdf\'s produced by the `save_print_and_play` function
can be configured in two different ways:

single-sided

:   Print single-sided on label paper, cut out the labels, and apply to
    components (in the material of your choice) or print single-sided on
    paper(board), apply adhesive to the back, fold over in half
    \"hot-dog-style\", and cut out the components. One will need to to
    some additional folding and application of adhesive/tape in order to
    construct the dice, pawns, and pyramids. One can build more
    dice/pawns/pawn belts if you cut them out *before* folding the
    paper(board) in half but if you don\'t do so you should still have
    all the \"standard\" piecepack components.

double-sided

:   Print double-sided on paper(board) and cut out the components. One
    will need to do some additional folding and application of
    adhesive/tape in order to construct the dice, pawns, and pyramids.

The [Piecepack Wiki](http://www.ludism.org/ppwiki/HomePage) has a page
on [making piecepacks](http://www.ludism.org/ppwiki/MakingPiecepacks).
The BoardGameGeek [Print-and-Play
Wiki](https://boardgamegeek.com/wiki/page/Print_and_Play_Games#) also
has lots of good info like how to [quickly make coins uisng an arch
punch](https://boardgamegeek.com/thread/507240/making-circular-tokens-and-counters-arch-punch).

**Warning:** Generally it is advisable to uncheck \'fit to size\' when
printing PDF files otherwise your components maybe re-sized by the
printer.

### What are the dimensions of the components?

Although one can use the API to make layouts with components of
different sizes the default print-and-play pdf\'s draw components of the
following size which (except for the pawns and non-standard \"pawn
belts\") matches the traditional [Mesomorph piecepack
dimensions](https://web.archive.org/web/20191222010028/http://www.piecepack.org/Anatomy.html)
if one uses the default component shapes and sizes:

-   tiles (default \"rect\") are drawn into a 2\" by 2\" square
-   coins (default \"circle\") are drawn into a ¾\" by ¾\" square
-   dice (default \"rect\") faces are drawn into a ½\" by ½\" square
-   pawn sides (default \"halma\") are drawn into a ½\" by ⅞\" rectangle
-   \"pawn belts\" (default \"rect\") are drawn into a ¾π\" by ½\"
    rectangle
-   \"pawn saucers\" (default \"circle\") are drawn into a ⅞\" by ⅞\"
    square

Components are drawn into rectangular drawing spaces (which are always
squares except for pawn components). The program allows one to customize
piecepack component shapes. If a components shape is `rect` it will fill
up the entire rectangular drawing space, if it is a `circle` then the
rectangular drawing space will be circumscribed around the circle. If a
components shape is a `convex#` or `concave#` where `#` is the number of
exterior vertices then the rectangular drawing space will be
circumscribed around a circle that will be circumscribed around that
convex/concave polygon. The rectangular drawing space also is
circumscribed around the special `halma`, `kite`, and `pyramid` shapes.

**Warning:** Generally it is advisable to uncheck \'fit to size\' when
printing PDF files otherwise your components maybe re-sized by the
printer.

### What are the possible color options?

You can specify colors either by [RGB hex color
codes](https://www.color-hex.com/) or [R color
strings](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf).
\"transparent\" is a color option which does what you\'d expect it to
(if used for something other than the background color will render the
element effectively invisible). **Warning:** you shouldn\'t mix
\"transparent\" backgrounds with the `invert_colors` options.

### I have some images I want to use as suit/rank/directional mark symbols, how can I use them with this program?

There are a couple of approaches one can take:

1.  Take them and put them into a font.
    [FontForge](https://fontforge.org/en-US/) is a popular
    open-source program suitable for this task.
    [fontcustom](https://github.com/FontCustom/fontcustom) is a popular
    command-line wrapper around FontForge. You may need to convert your
    images from one format to another format first. To guarantee
    dispatch by `fontconfig` you might want to put the symbols in a part
    of the \"Private Use Area\" of Unicode not used by any other fonts
    on your system. If you do that you won\'t need to specify your font
    otherwise you\'ll need to configure the `suit_symbols_font`,
    `rank_symbols_font`, and/or `dm_font` options.
2.  Write a custom grob function to insert the desired symbols using
    functions like `grid`\'s `rasterGrob` or `grImport2`\'s
    `pictureGrob`.

### Why does the package sometimes use a different font then the one I instructed it to use for a particular symbol?

The program uses `Cairo` which uses `fontconfig` to select fonts.
`fontconfig` picks what it thinks is the \'best\' font and sometimes it
annoyingly decides that the font to use for a particular symbol is not
the one you asked it to use. (although sometimes the symbol it chooses
instead still looks nice in which case maybe you shouldn\'t sweat it).
It is hard but not impossible to [configure which
fonts](https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/)
are dispatched by fontconfig. A perhaps easier way to guarantee your
symbols will be dispatched would be to either make a new font and
re-assign the symbols to code points in the Unicode \"Private Use Area\"
that aren\'t used by any other font on your system or to simply
temporarily move (or permanently delete) from your system font folders
the undesired fonts that `fontconfig` chooses over your requested fonts:

    # temporarily force fontconfig to use Noto Emoji instead of Noto Color Emoji in my piecepacks on Ubuntu 18.04
    $ sudo mv /usr/share/fonts/truetype/noto/NotoColorEmoji.ttf ~/
    ## Make some piecepacks
    $ sudo mv ~/NotoColorEmoji.ttf /usr/share/fonts/truetype/noto/

Also as a sanity check use the command-line tool `fc-match` (or the R
function `systemfonts::match_font`) to make sure you specified your font
correctly in the first place (i.e. `fc-match "Noto Sans"` on my system
returns \"Noto Sans\" but `fc-match "Sans Noto"` returns \"DejaVu Sans\"
and not \"Noto Sans\" as one may have expected). To help determine which
fonts are actually being embedded you can use the `get_embedded_font`
helper function:

``` {.r}
fonts <- c('Noto Sans Symbols2', 'Noto Emoji', 'sans')
chars <- c('♥', '♠', '♣', '♦', '🌞' ,'🌜' ,'꩜')
get_embedded_font(fonts, chars)
#     char      requested_font            embedded_font
# 1      ♥ Noto Sans Symbols2 NotoSansSymbols2-Regular
# 2      ♠ Noto Sans Symbols2 NotoSansSymbols2-Regular
# 3      ♣ Noto Sans Symbols2 NotoSansSymbols2-Regular
# 4      ♦ Noto Sans Symbols2 NotoSansSymbols2-Regular
# 5       🌞Noto Sans Symbols2                NotoEmoji
# 6       🌜Noto Sans Symbols2                NotoEmoji
# 7      ꩜ Noto Sans Symbols2     NotoSansCham-Regular
# 8      ♥         Noto Emoji                NotoEmoji
# 9      ♠         Noto Emoji                NotoEmoji
# 10     ♣         Noto Emoji                NotoEmoji
# 11     ♦         Noto Emoji                NotoEmoji
# 12      🌞        Noto Emoji                NotoEmoji
# 13      🌜        Noto Emoji                NotoEmoji
# 14     ꩜         Noto Emoji     NotoSansCham-Regular
# 15     ♥               sans                    Arimo
# 16     ♠               sans                    Arimo
# 17     ♣               sans                    Arimo
# 18     ♦               sans                    Arimo
# 19      🌞              sans                NotoEmoji
# 20      🌜              sans                NotoEmoji
# 21     ꩜               sans     NotoSansCham-Regular
```

### How do I use this package in piecepack rulesets?

There are two main ways that this package could be used to help make
piecepack rulesets:

1)  The `save_piece_images` function makes individual images of
    components. By default it makes them in the svg formats with
    rotations of 0 degrees but with configuration can also make them in
    the bmp, jpeg, pdf, png, ps, and tiff formats as well as 90, 180,
    and 270 degree rotations. These can be directly inserted into your
    ruleset or even used to build diagrams with the aid of a graphics
    editor program. An example filename is `tile_face_s1_r5_t180.pdf`
    where `tile` is the component, `face` is the side, `s1` indicates it
    was the first suit, `r5` indicates it was the 5th rank, `t180`
    indicates it was rotated 180 degrees, and `pdf` indicates it is a
    pdf image.
2)  This R package can be directly used with the `grid` graphics library
    in R to make diagrams. The important function for diagram drawing
    exported by the `piecepack` R package is `grid.piece` (or
    alternatives like `pmap_piece`) which draws piecepack components to
    the graphics device. The
    [ppgames](https://github.com/piecepackr/ppgames) R package has code
    for several [game diagram
    examples](https://trevorldavis.com/piecepackr/tag/ppgames.html). One
    can also use this package to [make
    animations](https://trevorldavis.com/piecepackr/animations.html).
