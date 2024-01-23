export PROJ_DIR=~/git/tstephen-bpmn-miwg-demos/2023
# export CMD=kpctl # requires at least v3.2.4 (unreleased)
cd ~/git/bpaas/cli
export CMD="poetry run kpctl"

#
# customer_onboarding_en.bpmn
#
$CMD -v 0 set customer_onboarding_en bpmn:documentation "Onboard a new customer policy" $PROJ_DIR/customer_onboarding_en.bpmn

$CMD set ServiceTask_CancelApplication @implementation kp:http $PROJ_DIR/customer_onboarding_en.bpmn
$CMD set ServiceTask_DeliverPolicy @implementation kp:http $PROJ_DIR/customer_onboarding_en.bpmn
$CMD set ServiceTask_GetCreditScore @implementation kp:http $PROJ_DIR/customer_onboarding_en.bpmn
$CMD set ServiceTask_RejectPolicy @implementation kp:http $PROJ_DIR/customer_onboarding_en.bpmn
$CMD set SendTask_ReportFraud @implementation kp:http $PROJ_DIR/customer_onboarding_en.bpmn

$CMD set SendTask_SendPolicy @implementation kp:mail $PROJ_DIR/customer_onboarding_en.bpmn
$CMD setextension SendTask_SendPolicy text "a placeholder message" $PROJ_DIR/customer_onboarding_en.bpmn

$CMD set SendTask_SendRejection @implementation kp:mail $PROJ_DIR/customer_onboarding_en.bpmn
$CMD setextension SendTask_SendRejection text "a placeholder message" $PROJ_DIR/customer_onboarding_en.bpmn

# Does not create resource only references it
$CMD setresource UserTask_HandleTimeout supervisor $PROJ_DIR/customer_onboarding_en.bpmn

$CMD set Activity_ManualCheck @calledElement ManualCheck $PROJ_DIR/customer_onboarding_en.bpmn

#$CMD validate $PROJ_DIR/customer_onboarding_en.bpmn

#
# manual_decision.bpmn
#

$CMD -v 0 set ManualCheck bpmn:documentation "Refer to underwriter for decision" $PROJ_DIR/manual_decision.bpmn

$CMD set CallActivity_RequestDocument @calledElement requestDocument_en $PROJ_DIR/manual_decision.bpmn

$CMD set SendTask_NotifyCustomerDelay @implementation kp:mail $PROJ_DIR/manual_decision.bpmn
$CMD setextension SendTask_NotifyCustomerDelay text "a placeholder message" $PROJ_DIR/manual_decision.bpmn

$CMD setresource UserTask_DecideOnApplication underwriter $PROJ_DIR/manual_decision.bpmn
$CMD setresource UserTask_AccelerateDecision underwriter $PROJ_DIR/manual_decision.bpmn
$CMD setresource UserTask_CheckForFraud fraud_team $PROJ_DIR/manual_decision.bpmn

#$CMD validate $PROJ_DIR/manual_decision.bpmn

#
# document_request_en.bpmn
#
$CMD -v 0 set requestDocument_en bpmn:documentation "Request documents from customer" $PROJ_DIR/document_request_en.bpmn

$CMD set SendTask_RequestDocument @implementation kp:mail $PROJ_DIR/document_request_en.bpmn
$CMD setextension SendTask_RequestDocument text "a placeholder message" $PROJ_DIR/document_request_en.bpmn

$CMD set SendTask_SendReminderEmail @implementation kp:mail $PROJ_DIR/document_request_en.bpmn
$CMD setextension SendTask_SendReminderEmail text "a placeholder message" $PROJ_DIR/document_request_en.bpmn

$CMD setresource UserTask_CallCustomer supervisor $PROJ_DIR/document_request_en.bpmn
#$CMD set UserTask_CallCustomer @kp:formKey kp:mail $PROJ_DIR/document_request_en.bpmn

#$CMD validate $PROJ_DIR/document_request_en.bpmn

# package app
$CMD package $PROJ_DIR
