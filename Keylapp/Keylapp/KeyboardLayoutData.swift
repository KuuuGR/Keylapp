//
//  KeyboardLayoutData.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import Foundation

// KeyboardLayoutData.swift

let keyboardLayouts: [KeyboardLayout] = [
    KeyboardLayout(id: "001", name: "QWERTY", firstRow: "qwfpbjluy;", secondRow: "arstgmneio", thirdRow: "zxcdvkh,./"),
    KeyboardLayout(id: "002", name: "Graphite", firstRow: "bldwz'fouj", secondRow: "nrtsgyhaei", thirdRow: "qxmcvkp.-/"),
    KeyboardLayout(id: "003", name: "Colemak", firstRow: "qwfpgjluy;", secondRow: "arstdhneio", thirdRow: "zxcvbkm,./"),
    // GQTODO: Add more layouts here
]


/*
 
 let rawLayouts: [String] = [
     "QWERTY", "qwfpbjluy;\narstgmneio\nzxcdvkh,./",
     "Graphite", "bldwz'fouj\nnrtsgyhaei\nqxmcvkp.-/",
     "Colemak", "qwfpgjluy;\narstdhneio\nzxcvbkm,./",
     "Dvorak", "',.pyfgcrl\naoeuidhtns\n;qjkxbmwvz",
     "Romak", "qbmgkxlouy\ndnstwzraei\n/fcpvjh,.;",
     "Colemak Mod-DH", "qwfpbjluy;\narstgmneio\nzxcdvkh,./",
     "Canary", "wlypkzxou;\ncrstbfneia\njvdgqmh?,.",
     "Sturdy", "vmlcpxfouj\nstrdy.naei\nzkqgwbh';,",
     "Hands-Down Polyglot", "wgmf TAB 'uokj\nrsntbyaeih\nxcldv-p;./",
     "Engram (Arno’s Engram)", "byou'ldwvz\nciea,htsnq\ngxjk-rmfp?",
     "BEAKL27", "qhouxgcmrv\nyiea.dstnb\nj\",k'wflpz",
     "Apt", "qcdlxzyou;\nrsthkpneia\nwbgmvjf,./",
     "Apt3", "wgdfbqluoy\nrsthkjneai\nxcmpvz,.'/",
     "Pycnantha", "frdpvzqou,\nsntcykhaei\nxjbgwml';.",
     "Recurva", "frdpvqjuoy\nsntcb.heai\nzxkgwml;',",
     "Hands Down Elan", "'wmpqjyouz\nrsntgkheai\nxcldbvf-;/",
     "Halmak", "wlrbz;qudj\nshnt,.aeoi\nfmvc/gpxky",
     "Hieamtsrn (gq-fix)", "byou'kdclp\nhiea,mtsrn\nxvq./wgfjz",
     "Hieamtsrn - Optimized", "jyou'kdclp\nhiea,mtsrn\nxqf.;zwgbv",
     "Norman", "qwdfkjurl;\nasetgynioh\nzxcvbpm,./",
     "Workman", "qdrwbjfup;\nashtgyneoi\nzxmcvkl,./",
     "MTGap 2.0", ",fhdkjcul.\noantgmseri\nqxbpzyw'v;",
     "qgmlwb", "qgmlwbyuv;\ndstnriaeoh\nzxcfjkp,./",
     "qgmlwy", "qgmlwyfub;\ndstnriaeoh\nzxcvjkp,./",
     "qfmlwy", "qfmlwyuobj\ndstnriaeh;\nzvgcxpk,./",
     "Asset", "qwjfgypul;\nasetdhnior\nzxcvbkm,./",
     "Capewell-Dvorak", "',.pyqfgrk\noaeiudhtns\nzxcvjlmwb;",
     "Klausler", ".uypqkldcg\neainwrhtso\n',;fzjmvbx",
     "Klausler second", "k,uypwlmfc\noaeidrnths\nq.';zxvgbj",
     "Norman", "qwdfkjurl;\nasetgynioh\nzxcvbpm,./",
     "Semimak JQ", "flhvz'wuoy\nsrntkcdeai\nxjbmqpg,./",
     "rstlne", "qwdfz;ukyp\naserlhniot\ngxcv?bjm,.",
     "Whorf", "flhdmvwou,\nsrntkgyaei\nxjbzqpc';.",
     "recurva-colstag", "frdpvqmuoy\nsntcb.heai\nzxkgwjl;',",
     "recurva-colstag2", "frdpvqluoy\nsntcbmheai\nzxkgwj.;',",
     "ruthenium", "wdlfxqbuoy\nrthsg.neai\njkmcvzp',;",
     "tungsten", "frdwvzluoy\nsntcpkheai\njxmgbq,;.'",
     "argon", "frldwzvuoy\nsnhcgkteai\nx/mpbjq,.'",
     "sulfer", "fndlj'wouy\nsrthmpcaei\nzxbkvqg.;,",
     "cobalt", "fdlgvz,uoy\nsthcwqneai\njkmpbxr;'.",
     "Sertain", "xldkvzwou;\nsrtnfgyeia\nqjmhbpc',.",
     "Nerts", "pldgvzkou;\nnrtswyheia\nqjmcxbf',.",
     "Nerps", "xldpgzkou;\nnrtswyheia\nqjmcvbf',."
     // Add other layouts as needed
 ]
 
 */





/*
let rawLayouts: [String] = [
    """
    QWERTY
    qwfpbjluy;
    arstgmneio
    zxcdvkh,./
    """,
    """
    Graphite
    bldwz'fouj
    nrtsgyhaei
    qxmcvkp.-/
    """,
    """
    Colemak
    qwfpgjluy;
    arstdhneio
    zxcvbkm,./
    """,
    """
    Dvorak
    ',.pyfgcrl
    aoeuidhtns
    ;qjkxbmwvz
    """,
    """
    Romak
    qbmgkxlouy
    dnstwzraei
    /fcpvjh,.;
    """,
    """
    Colemak Mod-DH
    qwfpbjluy;
    arstgmneio
    zxcdvkh,./
    """,
    """
    Canary
    wlypkzxou;
    crstbfneia
    jvdgqmh?,.
    """,
    """
    Sturdy
    vmlcpxfouj
    strdy.naei
    zkqgwbh';,
    """,
    """
    Hands-Down Polyglot
    wgmf TAB 'uokj
    rsntbyaeih
    xcldv-p;./
    """,
    """
    Engram (Arno’s Engram)
    byou'ldwvz
    ciea,htsnq
    gxjk-rmfp?
    """,
    """
    BEAKL27
    qhouxgcmrv
    yiea.dstnb
    j",k'wflpz
    """,
    """
    Apt
    qcdlxzyou;
    rsthkpneia
    wbgmvjf,./
    """,
    """
    Apt3
    wgdfbqluoy
    rsthkjneai
    xcmpvz,.'/
    """,
    """
    Pycnantha
    frdpvzqou,
    sntcykhaei
    xjbgwml';.
    """,
    """
    Recurva
    frdpvqjuoy
    sntcb.heai
    zxkgwml;',
    """,
    """
    Hands Down Elan
    'wmpqjyouz
    rsntgkheai
    xcldbvf-;/
    """,
    """
    Halmak
    wlrbz;qudj
    shnt,.aeoi
    fmvc/gpxky
    """,
    """
    Hieamtsrn (gq-fix)
    byou'kdclp
    hiea,mtsrn
    xvq./wgfjz
    """,
    """
    Hieamtsrn - Optimized
    jyou'kdclp
    hiea,mtsrn
    xqf.;zwgbv
    """,
    """
    Norman
    qwdfkjurl;
    asetgynioh
    zxcvbpm,./
    """,
    """
    Workman
    qdrwbjfup;
    ashtgyneoi
    zxmcvkl,./
    """,
    """
    MTGap 2.0
    ,fhdkjcul.
    oantgmseri
    qxbpzyw'v;
    """,
    """
    qgmlwb
    qgmlwbyuv;
    dstnriaeoh
    zxcfjkp,./
    """,
    """
    qgmlwy
    qgmlwyfub;
    dstnriaeoh
    zxcvjkp,./
    """,
    """
    qfmlwy
    qfmlwyuobj
    dstnriaeh;
    zvgcxpk,./
    """,
    """
    Asset
    qwjfgypul;
    asetdhnior
    zxcvbkm,./
    """,
    """
    Capewell-Dvorak
    ',.pyqfgrk
    oaeiudhtns
    zxcvjlmwb;
    """,
    """
    Klausler
    .uypqkldcg
    eainwrhtso
    ',;fzjmvbx
    """,
    """
    Klausler second
    k,uypwlmfc
    oaeidrnths
    q.';zxvgbj
    """,
    """
    Norman
    qwdfkjurl;
    asetgynioh
    zxcvbpm,./
    """,
    """
    Semimak JQ
    flhvz'wuoy
    srntkcdeai
    xjbmqpg,./
    """,
    """
    rstlne
    qwdfz;ukyp
    aserlhniot
    gxcv?bjm,.
    """,
    """
    Whorf
    flhdmvwou,
    srntkgyaei
    xjbzqpc';.
    """,
    """
    recurva-colstag
    frdpvqmuoy
    sntcb.heai
    zxkgwjl;',
    """,
    """
    recurva-colstag2
    frdpvqluoy
    sntcbmheai
    zxkgwj.;',
    """,
    """
    ruthenium
    wdlfxqbuoy
    rthsg.neai
    jkmcvzp',;
    """,
    """
    tungsten
    frdwvzluoy
    sntcpkheai
    jxmgbq,;.'
    """,
    """
    argon
    frldwzvuoy
    snhcgkteai
    x/mpbjq,.'
    """,
    """
    sulfer
    fndlj'wouy
    srthmpcaei
    zxbkvqg.;,
    """,
    """
    cobalt
    fdlgvz,uoy
    sthcwqneai
    jkmpbxr;'.
    """,
    """
    Sertain
    xldkvzwou;
    srtnfgyeia
    qjmhbpc',.
    """,
    """
    Nerts
    pldgvzkou;
    nrtswyheia
    qjmcxbf',.
    """,
    """
    Nerps
    xldpgzkou;
    nrtswyheia
    qjmcvbf',.
    """ // Repeat for other layouts
]
 */
