//
//  KeyboardLayoutData.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import Foundation
import SwiftUI

let rawLayouts: [String] = [
    """
    QWERTY
    qwertyuiop
    asdfghjkl;
    zxcvbnm,./
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
    wgmf↹'uokj
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
    """
]

let keyboardLayouts: [KeyboardLayout] = LayoutDataManager.shared.parseRawLayouts(rawLayouts)


//Usefull symbol source: https://symbl.cc/en/search/?q=tab
