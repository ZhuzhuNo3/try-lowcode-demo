#!/usr/bin/env bash

# 因为没研究如何使用table创建对话列表，所以手动改了下schema

# jq '. as $base |
#   ["u","a"] as $roles |
#   0 | while(.<4; .+1) | . as $idx |
#   ($roles[$idx%2] + ($idx/2%100|tostring)) as $suffix |
#   $base[$idx%2] |
#   .id = "node_dialog_box_"+$suffix |
#   .props.ref = "box-dialog_"+$suffix |
#   .title = $suffix |
#   .children[0].id = "node_dialog_msg_" + $suffix |
#   .children[0].props.ref = "message-dialog-" + $suffix |
#   .children[0].props.children.id = "node_dialog_slot-" + $suffix |
#   .children[0].props.children.value[0].id = "node_dialog_textarea-" + $suffix |
#   .children[0].props.children.value[0].props.ref = "input.textarea-dialog-" + $suffix
#   ' temp.json
# exit 0
# 拿所有的box
jq '.componentsTree[0].children[] |=
(select(.id=="node_oclfjpfqjy5") |=
(.children[0].children[0].children[0].children[] |=
(select(.id=="node_oclnmxovts60") |=
(.children[0].children[0].children[] |=
(select(.props.title=="DIALOG") |=
(.children[0].children|= [ . as $base |
  ["u","a"] as $roles |
  0 | while(.<201; .+1) | . as $idx |
  ($roles[$idx%2] + ($idx/2%1000|tostring)) as $suffix |
  $base[$idx%2] |
  .id = "node_dialog_box_"+$suffix |
  .props.ref = "box-dialog_"+$suffix |
  .title = $suffix |
  .children[0].id = "node_dialog_msg_" + $suffix |
  .children[0].props.ref = "message-dialog-" + $suffix |
  .children[0].props.children.id = "node_dialog_slot-" + $suffix |
  .children[0].props.children.value[0].id = "node_dialog_textarea-" + $suffix |
  .children[0].props.children.value[0].props.ref = "input.textarea-dialog-" + $suffix ]
  ))))))' projectSchema.txt
