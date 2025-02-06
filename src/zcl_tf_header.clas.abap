CLASS zcl_tf_header DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    class-METHODS getRemark FOR table FUNCTION ZTUMTF_HEADER.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_tf_header IMPLEMENTATION.
  METHOD getremark
  by DATABASE FUNCTION FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
*DETERMINISTIC
 USING ZTUM_HEADER.

  return
  select
  client,
  docno,
  status,
  case
  when status = 'Approved' then 'Approved By Manan'
  when status = 'Rejected' then 'Rejected By Manan'
  else 'Pending'
  end as remark,
  case
  when company_code = 'LSIHQ' then 'InvenioLSI Headquater'
  when company_code = 'LSID' then 'InvenioLSI Delhi'
  else 'InvenioLSI'
  end as compname
  from ZTUM_HEADER;
  ENDMETHOD.

ENDCLASS.
