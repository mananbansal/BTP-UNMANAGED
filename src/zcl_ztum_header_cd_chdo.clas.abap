class ZCL_ZTUM_HEADER_CD_CHDO definition
  public
  create public .

public section.

  interfaces IF_CHDO_ENHANCEMENTS .

  types:
     BEGIN OF TY_ZTUM_HEADER .
      INCLUDE TYPE ZTUM_HEADER.
      INCLUDE TYPE IF_CHDO_OBJECT_TOOLS_REL=>TY_ICDIND.
 TYPES END OF TY_ZTUM_HEADER .
  types:
    TT_ZTUM_HEADER TYPE STANDARD TABLE OF TY_ZTUM_HEADER .

  class-data OBJECTCLASS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTCL read-only value 'ZTUM_HEADER_CD' ##NO_TEXT.

  class-methods WRITE
    importing
      !OBJECTID type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTV
      !UTIME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUZEIT
      !UDATE type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDDATUM
      !USERNAME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUSERNAME
      !PLANNED_CHANGE_NUMBER type IF_CHDO_OBJECT_TOOLS_REL=>TY_PLANCHNGNR default SPACE
      !OBJECT_CHANGE_INDICATOR type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default 'U'
      !PLANNED_OR_REAL_CHANGES type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !NO_CHANGE_POINTERS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !XZTUM_HEADER type TT_ZTUM_HEADER optional
      !YZTUM_HEADER type TT_ZTUM_HEADER optional
      !UPD_ZTUM_HEADER type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default SPACE
    exporting
      value(CHANGENUMBER) type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHANGENR
    raising
      CX_CHDO_WRITE_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZTUM_HEADER_CD_CHDO IMPLEMENTATION.


  method WRITE.
*"----------------------------------------------------------------------
*"         this WRITE method is generated for object ZTUM_HEADER_CD
*"         never change it manually, please!        :02/06/2025
*"         All changes will be overwritten without a warning!
*"
*"         CX_CHDO_WRITE_ERROR is used for error handling
*"----------------------------------------------------------------------

    DATA: l_upd        TYPE if_chdo_object_tools_rel=>ty_cdchngind.

    CALL METHOD cl_chdo_write_tools=>changedocument_open
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        planned_change_number   = planned_change_number
        planned_or_real_changes = planned_or_real_changes.

    IF ( YZTUM_HEADER IS INITIAL ) AND
       ( XZTUM_HEADER IS INITIAL ).
      l_upd  = space.
    ELSE.
      l_upd = UPD_ZTUM_HEADER.
    ENDIF.

    IF l_upd NE space.
      CALL METHOD CL_CHDO_WRITE_TOOLS=>changedocument_multiple_case
        EXPORTING
          tablename              = 'ZTUM_HEADER'
          change_indicator       = UPD_ZTUM_HEADER
          docu_delete            = ''
          docu_insert            = ''
          docu_delete_if         = ''
          docu_insert_if         = ''
          table_old              = YZTUM_HEADER
          table_new              = XZTUM_HEADER
                  .
    ENDIF.

    CALL METHOD cl_chdo_write_tools=>changedocument_close
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        date_of_change          = udate
        time_of_change          = utime
        username                = username
        object_change_indicator = object_change_indicator
        no_change_pointers      = no_change_pointers
      IMPORTING
        changenumber            = changenumber.

  endmethod.
ENDCLASS.
