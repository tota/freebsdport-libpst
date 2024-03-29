# Created by: Nate Underwood <natey@natey.com>
# $FreeBSD$

PORTNAME=	libpst
PORTVERSION=	0.6.55
CATEGORIES=	mail converters
MASTER_SITES=	http://www.five-ten-sg.com/libpst/packages/ \
		http://fossies.org/unix/privat/

MAINTAINER=	chifeng@gmail.com
COMMENT=	A tool for converting Outlook .pst files to mbox and other formats

LICENSE=	GPLv2

GNU_CONFIGURE=	yes
USE_GMAKE=	yes
USE_ICONV=	yes
CPPFLAGS+=	-I${LOCALBASE}/include
LDFLAGS+=	-L${LOCALBASE}/lib -liconv
CONFIGURE_ARGS+=	--disable-python

MAN1=	lspst.1 pst2dii.1 pst2ldif.1 readpst.1
MAN5=	outlook.pst.5

OPTIONS_DEFINE=	DOCS PST2DII
PST2DII_DESC=	"allow Summation Document Image Information output"

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MDOCS}
PORTDOCS=	*
.endif

.if ${PORT_OPTIONS:MPST2DII}
CONFIGURE_ARGS+=	--enable-dii=yes
BUILD_DEPENDS+=	${LOCALBASE}/bin/convert:${PORTSDIR}/graphics/ImageMagick
RUN_DEPENDS+=	${LOCALBASE}/bin/convert:${PORTSDIR}/graphics/ImageMagick
LIB_DEPENDS+=	gd:${PORTSDIR}/graphics/gd
PLIST_SUB+=	PST2DII=""
.else
CONFIGURE_ARGS+=	--enable-dii=no
PLIST_SUB+=	PST2DII="@comment "
.endif

post-patch:
	${FIND} -X ${WRKSRC} -type f | ${XARGS} ${REINPLACE_CMD} -i "" \
		-e 's/malloc.h/stdlib.h/g'
	${REINPLACE_CMD} -e 's;doc\/@PACKAGE@-@VERSION@;doc\/@PACKAGE@;g' \
		${WRKSRC}/Makefile.in ${WRKSRC}/html/Makefile.in
.if ${PORT_OPTIONS:MDOCS}
	${REINPLACE_CMD} -e '/html_DATA =/s/COPYING //' \
		${WRKSRC}/Makefile.in
.else
	${REINPLACE_CMD} -e '/SUBDIRS =/s/=.*/= src man/' -e '/html_DATA =/d' \
		${WRKSRC}/Makefile.in
.endif

.include <bsd.port.mk>
