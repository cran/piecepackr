#' Create graphics using data frame input
#'
#' \code{pmap_piece} operates on the rows of a data frame
#'     applying \code{.f} to each row (usually \code{grid.piece}).
#'
#' \code{pmap_piece} differs from \code{purrr::pmap} in a few ways
#' \enumerate{
#'    \item{If \code{cfg} and/or \code{envir} are missing attempts to set reasonable defaults.}
#'    \item{If not \code{NULL} will first apply function \code{trans} to \code{.l}.}
#'    \item{If the output of \code{.f} is a grid grob object then \code{pmap_piece}
#'          will return a \code{gTree} object with
#'          specified \code{name}, \code{gp}, and \code{vp} values and if \code{draw} is true draw it.}
#'    \item{If \code{.l} lacks a \code{name} column or if \code{name} column is non-unique
#'          attempts to generate a reasonable new default \code{name} column
#'          and use that to name the return \code{gTree} children  or \code{list} values.}
#'  }
#' @inheritParams grid.piece
#' @param .l A list of vectors, such as a data frame. The length of \code{.l}
#'           determines the number of arguments that \code{.f}
#'           will be called  with. List names will be used if present.
#' @param .f Function to be applied to \code{.l} after adjustments to
#'        \code{cfg} and \code{envir} and the application of \code{trans}.
#' @param trans Function to modify \code{.l} before drawing.
#'        Default (\code{NULL}) is to not modify \code{.l}.  \code{op_transform}
#'        can help with using an oblique projection (i.e. \code{op_scale} over 0).
#' @param ... Extra arguments to pass to \code{.f}.
#' @examples
#'   if (require("grid")) {
#'        dark_colorscheme <- list(suit_color="darkred,black,darkgreen,darkblue,black",
#'                             invert_colors.suited=TRUE, border_color="black", border_lex=2)
#'        traditional_ranks <- list(use_suit_as_ace=TRUE, rank_text=",a,2,3,4,5")
#'        cfg3d <- list(width.pawn=0.75, height.pawn=0.75, depth.pawn=1,
#'                           dm_text.pawn="", shape.pawn="convex6", invert_colors.pawn=TRUE,
#'                           edge_color.coin="tan", edge_color.tile="tan")
#'        cfg <- pp_cfg(c(dark_colorscheme, traditional_ranks, cfg3d))
#'        grid.newpage()
#'        df_tiles <- data.frame(piece_side="tile_back", x=0.5+c(3,1,3,1), y=0.5+c(3,3,1,1),
#'                               suit=NA, angle=NA, z=NA, stringsAsFactors=FALSE)
#'        df_coins <- data.frame(piece_side="coin_back", x=rep(4:1, 4), y=rep(4:1, each=4),
#'                               suit=1:16%%2+rep(c(1,3), each=8),
#'                               angle=rep(c(180,0), each=8), z=1/4+1/16, stringsAsFactors=FALSE)
#'        df <- rbind(df_tiles, df_coins)
#'        pmap_piece(df, cfg=cfg, op_scale=0.5, default.units="in")
#'   }
#' @export
pmap_piece <- function(.l, .f = pieceGrob, ..., cfg=NULL, envir=NULL, trans=NULL,
                       draw=TRUE, name=NULL, gp=NULL, vp=NULL) {
    ce <- default_cfg_envir(cfg, envir)
    cfg <- ce$cfg
    envir <- ce$envir

    .l <- update_name(.l)
    if (is.function(trans)) {
        .l <- trans(.l, ..., cfg=cfg, envir=envir)
        .l <- update_name(.l)
    }
    if (hasName(.l, "cfg")) {
        ll <- purrr::pmap(.l, .f, ..., envir=envir, draw=FALSE)
    } else {
        ll <- purrr::pmap(.l, .f, ..., cfg=cfg, envir=envir, draw=FALSE)
    }
    if (length(ll) && all(sapply(ll, is.grob))) {
        grob <- gTree(children=as.gList(ll), name=name, gp=gp, vp=vp, cl="pmap_piece")
        if (draw) grid.draw(grob)
        invisible(grob)
    } else {
        names(ll) <- .l$name
        invisible(ll)
    }
}

update_name <- function(.l) {
    if (hasName(.l, "name")) {
        if (!is.character(.l$name)) .l$name <- as.character(.l$name)
        if (sum(duplicated(.l$name)) == 0) {
            return(.l)
        } else {
            warning("the name column in .l is not unique, generating new name column")
        }
    }
    if (hasName(.l, "id")) {
        .l$name <- paste0("piece.", as.character(.l$id))
        if (sum(duplicated(.l$name)) == 0) {
            return(.l)
        } else {
            warning("the id column in .l is not unique, generating new name column")
        }
    }
    .l$name <- paste0("piece.", as.character(seq(length(.l[[1]]))))
    .l
}

#' @export
grobPoints.pmap_piece <- function(x, closed = TRUE) {
    gc <- lapply(x$children, grobPoints)
    f <- function(x, y) gridGeometry::polyclip(x, y, "union")
    Reduce(f, gc)
}

as.gList <- function(ll) {
    gl <- gList()
    for (ii in seq(ll)) {
        gl[[ii]] <- ll[[ii]]
    }
    gl
}

default_cfg_envir <- function(cfg=NULL, envir=NULL) {
    if (is.null(cfg) && is.null(envir)) {
        cfg <- pp_cfg()
        envir <- game_systems()
    } else if (is.null(cfg)) { # and !is.null(envir)
        if (hasName(envir, "piecepack")) {
            cfg <- envir[["piecepack"]]
        } else {
            cfg <- pp_cfg()
        }
    } else if (is.null(envir)) { # and !is.null(cfg)
        cfg <- get_cfg(cfg)
        envir <- game_systems()
        envir[["piecepack"]] <- cfg
    }
    list(cfg=cfg, envir=envir)
}
