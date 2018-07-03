"""
# Function call

`phasor(c;origin=0.0+0.0im,ref=1,par=0,
    rlabel=0.5,tlabel=0.1,label="",ha="center",va="center",
    relrot=false,relangle=0,
    color="black",width=0.2,headlength=10,headwidth=5)`

# Description

This function draws a phasor from a starting point `origin` and end point
`origin`+`c`. The phasor consists of a shaft and an arrow head.

Each phasor c is plotted as a relative quanitity, i.e., `c/ref` is actually
shown the plot figure. This concept of plotting a per unit phasor is used to
be able to plot phasor with different quantities, e.g., voltage and current
phasors. It is important that the variables `c`, `origin` and `ref` have the
same units (defined through Unitful).

# Variables

`c` Complex phasor, drawn relative relative to `origin`

`origin` Complex number representing the origin of the phasor; this variable
needs to have the same unit as `c`

`ref` Reference length of scaling; this is required as in a pahasor diagram
voltages and currents may be included; in order to account for the different
voltage and current scales, one (constant)  `ref` is used for voltage
phasors and another (constant) `ref` is used for current phasors; this
variable needs to have the same unit as `c`

`par` In order to be able to plot parallel phasors, par is used to specify
the per unit tangential shift (offset) of a phasor, with respect to `ref`;
so typlically `ref` will be selected to be around 0.05 to 0.1;
default value = 0 (no shift of phasor)

`rlabel` radial per unit location of label (in direction of the phasor):
`rlabel = 0` represents the shaft of the phasor and `rlabel = 1` represents
the arrow hear of the phasor; default value = 0.5, i.e., the radial center
of the phasor

`tlabel` tangential per unit location of label: `tlabel = 0` means that the
label is plotted onto the phasor; `tlabel = -0.25` plots the label on top of
the phasor applying a displacement of 25% with respect to `ref`;
`tlabel = 0.2` plots the label below the
phasor applying a displacement of 20% with respect to `ref`; default value
= 0.25

`ha` horizontal alignment of label; actually represents the tangential
alignment of the label; default value = "center"
`linewidth` Line width of arrow shaft

`va` vertical alignment of label; actually represents the radial
alignment of the label; default value = "center"

`relrot` relative rotation of label; if `relrot == false` (default value)
then the label is not rotated relative to the orientation of the phasor;
otherwise the label is rotated relative to the phasor by the angle
`relangle` (indicated in degrees)

`relangle` relative angle of label in degree with respect to phasor
orientient; this angle is only appplied, it `relrot == true`; this angle the
indicates the relative orientation of the label with respect to the
orientation of the phasor; default value = 0

`color` color of the phasor; i.e., shaft and arrow head color; default
value = "black"

`width` line width of the shaft line; default value = 0.2

`headlength` lenght of arrow head; default value = 10

`headwidth` width of arrow head; default value = 5
"""
function phasor(c;origin=(0.0+0.0im).*c./ustrip(c),
    ref=abs(c./ustrip(c)),par=0.0,
    rlabel=0.5,tlabel=0.1,
    label="",
    ha="center",va="center",
    relrot=false,relangle=0.0,
    color="black",width=0.2,
    headlength=10.0,headwidth=5.0)

    # Check if units of c, origin and ref are compatible
    # Starting point (origin) of phase
    xorigin=0.0
    yorigin=0.0
    xend=0.0
    yend=0.0
    try
        xorigin=uconvert(Unitful.NoUnits,real(origin)./ref)
        yorigin=uconvert(Unitful.NoUnits,imag(origin)./ref)
        # End point of phasor
        xend=uconvert(Unitful.NoUnits,real(origin+c)./ref)
        yend=uconvert(Unitful.NoUnits,imag(origin+c)./ref)
    catch err
        error("module EE: function phasor: Dimension mismatch of arguments `c`, `origin` and `ref`\n    The arguments `c`, `origin` and `ref` must have the same dimension (koherent SI unit)")
    end

    # Real part of phasor
    drx=xend-xorigin # = real(c)./ref
    # Imag part of phasor
    dry=yend-yorigin # = imag(c)./ref
    # Length of phasor
    dr=sqrt(drx^2+dry^2)
    # Angle of phasor in degrees
    absangle=atan2(dry,drx)*180/pi
    # Orientation tangential to phasor (lagging by 90°)
    # Real part of tangential component with repsect to length
    dtx=+dry/dr
    # Imag part of tangential component with repsect to length
    dty=-drx/dr
    # Real part of parallel shift of phasor
    dpx=par*dtx
    # Imag part of parallel shift of phasor
    dpy=par*dty
    # Draw arrow
    annotate("",xy=(xend+dpx,yend+dpy),
        xytext=(xorigin+dpx,yorigin+dpy),xycoords="data",
        arrowprops=Dict("edgecolor"=>color,"facecolor"=>color,
            "width"=>width,"headlength"=>headlength,
            "headwidth"=>headwidth),
        annotation_clip=false)

    # Plot label
    if relrot==false
        # Without relative roation of label
        text(xorigin+drx*rlabel+dtx*tlabel+dpx,
            yorigin+dry*rlabel+dty*tlabel+dpy,
            label,ha=ha,va=va,rotation=relangle)
    else
        # Applying relative rotation of label
        text(xorigin+drx*rlabel+dtx*tlabel+dpx,
            yorigin+dry*rlabel+dty*tlabel+dpy,
            label,ha=ha,va=va,rotation=absangle+relangle)
    end
end