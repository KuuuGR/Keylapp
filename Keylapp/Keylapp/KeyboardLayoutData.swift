//
//  KeyboardLayoutData.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import Foundation
import SwiftUI


let keyboardLayouts: [KeyboardLayout] = LayoutDataManager.shared.parseRawLayouts(rawLayouts)
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
    """,
    """
    Memex🍠🐉🍈
    🥔🍎🍓🍉🍒🌶️🍇🥥🍅🧄
    🧀🍑🍋🍌🍐🌽🍆🍊🥕🎃
    🌿🥑🥝🥭🥬🥒🫐🍍🥦🧅
    """,
]

class KeyboardLayoutData {
    static func allLayouts() -> [KeyboardLayoutInfo] {
        return [
            KeyboardLayoutInfo(name: "Apt", description: "Apt is an ergonomic layout designed to reduce finger movement and increase typing efficiency. It is inspired by other efficient layouts like Colemak and Dvorak but introduces its own unique optimizations to minimize finger travel and promote a natural hand position."),
            KeyboardLayoutInfo(name: "Apt3", description: "Apt3 is an evolution of the Apt layout, with further refinements to key placements to enhance typing efficiency and comfort. It is ideal for users looking for a balance between speed and comfort, building on the strengths of Apt."),
            KeyboardLayoutInfo(name: "Argon", description: "Argon focuses on optimizing finger movement by placing frequently used keys under the strongest fingers, reducing physical strain and enhancing overall typing speed and comfort."),
            KeyboardLayoutInfo(name: "Asset", description: "Designed for professionals in asset management and financial sectors, Asset incorporates shortcuts and symbols commonly used in financial documentation, streamlining the typing process for these users."),
            KeyboardLayoutInfo(name: "BEAKL27", description: "BEAKL27 focuses on reducing finger travel and improving typing speed by optimizing key positions. It promotes ergonomic typing by placing the most frequently used keys in easily accessible positions."),
            KeyboardLayoutInfo(name: "Canary", description: "Canary is designed to maximize typing speed and comfort by rethinking key placements and finger movements. It shares goals with other efficient layouts but introduces unique optimizations for reduced finger travel."),
            KeyboardLayoutInfo(name: "Capewell-Dvorak", description: "A hybrid of Capewell and Dvorak layouts, Capewell-Dvorak combines the ergonomic benefits of both designs, reducing finger movement and distributing typing load more evenly."),
            KeyboardLayoutInfo(name: "Cobalt", description: "Cobalt aims to improve typing speed and reduce strain by placing commonly used keys under the strongest fingers, promoting a natural hand posture and preventing repetitive strain injuries."),
            KeyboardLayoutInfo(name: "Colemak", description: "Colemak reduces finger travel and increases typing efficiency while maintaining most QWERTY key placements for easier learning. It balances speed and comfort without a steep transition from QWERTY."),
            KeyboardLayoutInfo(name: "Colemak Mod-DH", description: "An ergonomic variant of Colemak, Colemak Mod-DH further optimizes finger movement by modifying certain key placements, reducing lateral finger movements and enhancing comfort for extended typing sessions."),
            KeyboardLayoutInfo(name: "Dvorak", description: "Designed to increase typing efficiency by placing the most common letters on the home row, Dvorak reduces finger movement and improves speed, despite limited adoption due to QWERTY's prevalence."),
            KeyboardLayoutInfo(name: "Engram (Arno’s Engram)", description: "Engram minimizes finger movement by placing the most frequently used letters in accessible positions, enhancing typing speed and ergonomics through a design based on letter frequency and biomechanical efficiency."),
            KeyboardLayoutInfo(name: "Graphite", description: "Graphite optimizes typing speed and comfort by reducing finger travel and promoting ergonomic hand positioning, making it easier to maintain a natural posture during typing."),
            KeyboardLayoutInfo(name: "Halmak", description: "Halmak places the most commonly used letters under the strongest fingers to improve typing efficiency and reduce strain, providing ergonomic benefits similar to other optimized layouts."),
            KeyboardLayoutInfo(name: "Hands Down Elan", description: "Promotes natural finger movements and reduces strain, enhancing overall typing comfort by minimizing finger travel and distributing typing load evenly."),
            KeyboardLayoutInfo(name: "Hands-Down Polyglot", description: "Optimized for multilingual users, facilitating easy switching between languages and providing efficient typing for various scripts and diacritical marks."),
            KeyboardLayoutInfo(name: "Hieamtsrn (gq-fix)", description: "Highly optimized for ergonomic benefits and efficient finger movements, with specific fixes for common issues, reducing strain and enhancing comfort during extended typing."),
            KeyboardLayoutInfo(name: "Hieamtsrn - Optimized", description: "An enhanced version of Hieamtsrn, further refined for optimal typing speed and comfort, with accessible placements for frequently used keys."),
            KeyboardLayoutInfo(name: "Klausler", description: "Focuses on ergonomic benefits and typing speed by reducing finger travel and distributing typing load evenly, enhancing comfort and preventing strain."),
            KeyboardLayoutInfo(name: "Klausler second", description: "An improved version of the original Klausler layout, with further refinements to key placements for enhanced ergonomic benefits and typing efficiency."),
            KeyboardLayoutInfo(name: "Memex", description: "Experimental layout designed to help users remember grid positions through visual and associative learning techniques, making it easier to master multiple layers and improve typing efficiency."),
            KeyboardLayoutInfo(name: "MTGap 2.0", description: "Designed to minimize finger travel distances and maximize typing speed based on comprehensive analysis of typing patterns, reducing strain and improving efficiency."),
            KeyboardLayoutInfo(name: "Nerps", description: "Focuses on low redirect and low same-finger bigram (SFB) principles to reduce awkward finger motions and minimize strain, providing a comfortable and efficient typing experience."),
            KeyboardLayoutInfo(name: "Nerts", description: "Similar to Nerps, emphasizing low redirect and low SFB principles to promote natural typing posture and reduce strain, enhancing overall comfort and speed."),
            KeyboardLayoutInfo(name: "Norman", description: "Balances typing efficiency and ease of learning, reducing finger movement and distributing typing load evenly, addressing issues found in other layouts for improved comfort."),
            KeyboardLayoutInfo(name: "Pycnantha", description: "Optimized for minimal finger movement and maximal typing speed, promoting efficient finger motions and a natural hand posture for extended typing sessions."),
            KeyboardLayoutInfo(name: "QFMLWY", description: "Specialized layout designed to reduce finger travel and increase typing speed by placing frequently used keys in accessible positions, promoting ergonomic benefits."),
            KeyboardLayoutInfo(name: "QGMLWB", description: "Custom layout focusing on reducing finger movement and improving typing speed through optimized key placement, enhancing comfort and preventing repetitive strain injuries."),
            KeyboardLayoutInfo(name: "QGMLWY", description: "Ergonomic layout designed to reduce finger travel and increase typing speed, with accessible placements for frequently used keys, promoting natural hand posture."),
            KeyboardLayoutInfo(name: "QWERTY", description: "The standard layout, designed to prevent typewriter jams, resulting in less efficient typing and higher strain compared to alternative layouts. Despite its inefficiencies, QWERTY remains the most widely used due to its familiarity."),
            KeyboardLayoutInfo(name: "Recurva", description: "Optimizes rolling finger motions to reduce typing fatigue and increase comfort, with key placements that allow for smooth and efficient typing."),
            KeyboardLayoutInfo(name: "Recurva-Colstag", description: "Variant of Recurva, with further refinements to key placements to enhance comfort and efficiency, reducing strain and increasing typing speed."),
            KeyboardLayoutInfo(name: "Recurva-Colstag2", description: "Improved version of recurva-colstag, with additional refinements for optimal typing performance, providing even more ergonomic benefits."),
            KeyboardLayoutInfo(name: "Romak", description: "Improves typing efficiency by optimizing key placements based on letter frequency and ergonomic principles, reducing finger travel and promoting a natural hand position."),
            KeyboardLayoutInfo(name: "RSTLNE", description: "Optimized for efficiency by focusing on the most commonly used letters in the English language, reducing finger travel and improving typing speed."),
            KeyboardLayoutInfo(name: "Ruthenium", description: "Custom layout designed to optimize typing speed and comfort, with key placements that reduce finger travel and promote a natural hand posture."),
            KeyboardLayoutInfo(name: "Semimak JQ", description: "Ergonomic layout optimizing key placements to reduce finger travel and improve typing speed, building on the principles of other efficient layouts."),
            KeyboardLayoutInfo(name: "Sertain", description: "Offers low redirect, low same-finger bigram (SFB), and low pinky usage, reducing awkward finger motions and minimizing strain, promoting a comfortable typing experience."),
            KeyboardLayoutInfo(name: "Sturdy", description: "Developed to address specific issues in existing layouts, Sturdy refines key placements to filter out problematic bigrams and improve overall typing feel, serving as a precursor to Graphite."),
            KeyboardLayoutInfo(name: "Sulfur", description: "Focuses on ergonomic benefits and typing efficiency, reducing finger travel and promoting a natural hand posture, enhancing overall comfort."),
            KeyboardLayoutInfo(name: "Tungsten", description: "Optimizes typing speed and comfort by reducing finger travel, placing commonly used keys under the strongest fingers, promoting a natural hand posture and preventing strain."),
            KeyboardLayoutInfo(name: "Whorf", description: "Emphasizes scoring systems and well-reasoned assumptions for optimizing typing efficiency, improving speed and reducing strain through extensive key placement analysis."),
            KeyboardLayoutInfo(name: "Workman", description: "Balances typing efficiency and comfort, reducing finger travel and distributing typing load evenly, addressing issues in other layouts and providing an efficient experience for English users."),
            // Add additional layouts based on the provided descriptions
        ]
    }
}
