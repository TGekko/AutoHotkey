#SingleInstance Force
#NoTrayIcon

call(function:="", parameters:="__", menuvariables*) {
 if(function == "")
  return
 if(parameters == "__") {
  function()
  return
 }
 if(Type(parameters) != "Array") {
  parameters := [parameters]
 }
 function(parameters*)
}

global ready := true
cast(spell) {
 if(ready == true) {
  ready := false
  for(i, element in StrSplit(spell)) {
   Send("{" element " down}{" element " up}")
   Sleep(105)
  }
  Send("{Space down}{Space up}")
  Sleep(500)
  ready := true
 }
}
lists := [[["Blizzard", "rrqr"], ["Charm [&0]", "wed"], ["Conflagration [&1]", "fqffqffq"], ["Confuse [&2]", "sea"], ["Corporealize [&3]", "sfqaes"], ["Crash to Desktop [&4]", "aafw"], ["Fear [&5]", "rse"], ["Grease", "qdw"], ["Haste", "asf"], ["Invisibility [&6]", "sefqs"], ["Meteor Shower [&7]", "fdfqdf"], ["Nullify", "se"]], [["Rain", "qqf"], ["Raise Dead [&8]", "rqdsr"], ["Revive", "wa"], ["Summon Death [&9]", "srrqrs"], ["Summon Elemental [&+]", "sedfqs"], ["Summon Phoenix", "waf"], ["Teleport", "asa"], ["Thunder Bolt", "fqasa"], ["Thunder Storm [ &. ]", "fqfqasa"], ["Time Warp", "re"], ["Tornado", "dfqqqf"], ["Vortex [ &- ]", "rqsrqerq"]], [["Chain Lightning", "aaa"], ["Levitation", "fqsfq"], ["Portal", "fqae"], ["Propp's Party Plasma", "ffqs"], ["Tractor Pull", "ds"]], [["Napalm", "fqdwff"]], [["Performance Enhancement", "wfafw"], ["Spray of Judgement", "rqrqse"], ["The Wave", "dfqdfqd"]]]
spellmenu := Menu()
for(i, spells in lists) {
 for(n, spell in spells) {
  if((i = 2 || i = 3) && n = 1) {
   spellmenu.Add(spell[1], call.bind(cast, spell[2]), "+BarBreak")
  } else {
   if(i > 1 and n = 1) {
    spellmenu.Add()
   }
   spellmenu.Add(spell[1], call.bind(cast, spell[2]))
  }
 }
}

#HotIf WinActive("Magicka") ; ahk_exe Magicka.exe
 !RButton::spellmenu.Show()
 Numpad0::cast("wed") ;        Charm
 Numpad1::cast("fqffqffq") ;   Conflagration
 Numpad2::cast("sea") ;        Confuse
 Numpad3::cast("sfqaes") ;     Corporealize
 Numpad4::cast("aafw") ;       Crash to Desktop
 Numpad5::cast("rse") ;        Fear
 Numpad6::cast("sefqs") ;      Invisibility
 Numpad7::cast("fdfqdf") ;     Meteor Storm
 Numpad8::cast("rqdsr") ;      Raise Dead
 Numpad9::cast("srrqrs") ;     Summon Death
 NumpadAdd::cast("sedfqs") ;   Summon Elemental
 NumpadDot::cast("fqfqasa") ;  Thunder Storm
 NumpadSub::cast("rqsrqerq") ; Vortex
#HotIf
