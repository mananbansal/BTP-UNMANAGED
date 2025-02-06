@EndUserText.label: 'table functin'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ZTUMTF_HEADER
//with parameters parameter_name : parameter_type
returns {
  client         : abap.clnt;
  docno          : z_doc_number;
  status         : z_status;
  remark         : abap.char( 50 );
  compname       : abap.char( 50 );
}
implemented by method ZCL_TF_HEADER=>getRemark;