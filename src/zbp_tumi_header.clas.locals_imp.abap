CLASS lhc_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.
  CLASS-DATA:
      lt_header_create TYPE STANDARD TABLE OF ztum_header WITH NON-UNIQUE DEFAULT KEY,
      ls_header_create TYPE ztum_header,

      lt_header_delete TYPE STANDARD TABLE OF ztum_header WITH NON-UNIQUE DEFAULT KEY,
      ls_header_delete TYPE ztum_header,

      lt_header_update TYPE STANDARD TABLE OF ztum_header WITH NON-UNIQUE DEFAULT KEY,
      ls_header_update TYPE ztum_header,

      lt_item_create   TYPE STANDARD TABLE OF ztum_item WITH NON-UNIQUE DEFAULT KEY,
      ls_item_create TYPE ztum_item.



  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR hdr RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE hdr.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE hdr.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE hdr.

    METHODS read FOR READ
      IMPORTING keys FOR READ hdr RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK hdr.

    METHODS rba_Item FOR READ
      IMPORTING keys_rba FOR READ hdr\_Item FULL result_requested RESULT result LINK association_links.

    METHODS cba_Item FOR MODIFY
      IMPORTING entities_cba FOR CREATE hdr\_Item.

    METHODS Approve FOR MODIFY
      IMPORTING keys FOR ACTION hdr~Approve RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
    IMPORTING keys REQUEST requested_features FOR hdr RESULT result.
    METHODS reject FOR MODIFY
      IMPORTING keys FOR ACTION hdr~reject RESULT result.




ENDCLASS.

CLASS lhc_hdr IMPLEMENTATION.

  METHOD get_instance_authorizations.
   LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_data>).

   read ENTITIES OF ztumi_header in LOCAL MODE
   ENTITY hdr
   ALL FIELDS WITH VALUE #( for key in keys ( %key = key-%key ) )
   result DATA(lv_result)
   FAILED failed.

   DATA(lv_allowed) =  COND #( WHEN lv_result[ 1 ]-Status = 'NEW'
                               THEN if_abap_behv=>auth-allowed
                               ELSE if_abap_behv=>auth-unauthorized
                               ).
    APPEND VALUE #( Docno = <ls_data>-Docno %action-Approve = lv_allowed   ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD create.

  SELECT docno FROM ztum_header ORDER BY docno DESCENDING INTO @DATA(lv_docno) UP TO 1 ROWS.
  ENDSELECT.

    IF lv_docno IS INITIAL.
        ls_header_create-docno = 'LSI0000001'.

    ELSE.
            DATA: lv_numeric_part TYPE n LENGTH 7,
                  lv_Mod_DocNo    TYPE string.

           lv_numeric_part = lv_docno+3(*).  " Remove the first 3 characters
           lv_numeric_part = lv_numeric_part + 1.
           lv_Mod_DocNo = |LSI{ lv_numeric_part WIDTH = 7 PAD = '0'  }|.

           ls_header_create-docno = lv_Mod_DocNo.

    ENDIF.
        get TIME STAMP FIELD data(lv_tmstmp).
       LOOP AT entities INTO DATA(entity).
*        MOVE-CORRESPONDING entity TO ls_header_create.

        ls_header_create-company_code = entity-CompanyCode.
        ls_header_create-purchase_org = entity-PurchaseOrg.
        ls_header_create-supplier_no = entity-SupplierNo.
        ls_header_create-Status      = entity-Status.
        ls_header_create-Currency    = entity-Currency.
        ls_header_create-changed_at  = entity-ChangedAt.
        ls_header_create-created_at  = entity-CreatedAt.
        ls_header_create-created_by  = entity-CreatedBy.
        ls_header_create-local_last_changed = lv_tmstmp.


        INSERT CORRESPONDING #( entity ) INTO TABLE mapped-hdr.
        INSERT CORRESPONDING #( ls_header_create ) INTO TABLE lt_header_create.

       ENDLOOP.

  ENDMETHOD.

  METHOD update.
  LOOP AT entities INTO DATA(entity).
  ENDLOOP.
  select SINGLE * from ztum_header where docno = @entity-Docno into @ls_header_update.

  if entity-%control-CompanyCode is not INITIAL.
  ls_header_update-company_code = entity-CompanyCode.
  ENDIF.
  if entity-%control-Status is not INITIAL.
  ls_header_update-status = entity-Status.
  ENDIF.
  if entity-%control-PurchaseOrg is not INITIAL.
  ls_header_update-purchase_org = entity-PurchaseOrg.
  ENDIF.
  if entity-%control-Currency is not INITIAL.
  ls_header_update-currency = entity-Currency.
  ENDIF.
  if entity-%control-SupplierNo is not INITIAL.
  ls_header_update-supplier_no = entity-SupplierNo.
  ENDIF.
  if entity-%control-ChangedAt is not INITIAL.
  ls_header_update-changed_at = entity-ChangedAt.
  ENDIF.
  if entity-%control-CreatedAt is not INITIAL.
  ls_header_update-created_at = entity-CreatedAt.
  ENDIF.
  if entity-%control-CreatedBy is not INITIAL.
  ls_header_update-created_by = entity-CreatedBy.
  ENDIF.

  get TIME STAMP FIELD data(lv_tmstmp).
  ls_header_update-local_last_changed = lv_tmstmp.

   INSERT CORRESPONDING #( entity ) INTO TABLE mapped-hdr.
   INSERT CORRESPONDING #( ls_header_update ) INTO TABLE lt_header_update.

  ENDMETHOD.

  METHOD delete.

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_del>).
        ls_header_delete-Docno = <ls_del>-DocNo.
        INSERT CORRESPONDING #( ls_header_delete ) INTO TABLE lt_header_delete.
        ENDLOOP.

  ENDMETHOD.

  METHOD read.
  SELECT * from ztumi_header for all ENTRIES IN @keys where Docno = @keys-Docno
  into CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD lock.
    TRY.
        DATA(lock) = cl_abap_lock_object_factory=>get_instance( iv_name = 'EZTUM_HEADER' ).

    CATCH cx_abap_lock_failure INTO DATA(exception).
            RAISE SHORTDUMP exception.

    ENDTRY.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

    TRY.
        lock->enqueue(
                  it_parameter = VALUE #( ( name = 'doc number' value = REF #( <fs_key>-Docno )  ) )
                        ).
        CATCH cx_abap_foreign_lock INTO DATA(foreign_lock).
                DATA(lv_user) = foreign_lock->user_name.
        CATCH cx_abap_lock_failure INTO exception.
                RAISE SHORTDUMP exception.
    ENDTRY.

    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Item.
  ENDMETHOD.

  METHOD cba_Item.
  SELECT item_no FROM ztum_item ORDER BY item_no DESCENDING INTO @DATA(lv_itmNo) UP TO 1 ROWS.
  ENDSELECT.

    IF lv_itmNo IS INITIAL.
        ls_item_create-item_no = 1.

    ELSE.
          ls_item_create-item_no = lv_itmNo  + 1.
    ENDIF.

  LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<fs_itm>).
      LOOP AT <fs_itm>-%target ASSIGNING FIELD-SYMBOL(<fs_item>).
  ls_item_create-docno = <fs_itm>-Docno.
  ls_item_create-status = <fs_item>-Status.
  ls_item_create-quantity = <fs_item>-Quantity.
  ls_item_create-currency = <fs_item>-Currency.
  ls_item_create-amount = <fs_item>-Amount.
  ls_item_create-tax_amt = <fs_item>-TaxAmt.
  ls_item_create-changed_at = <fs_item>-ChangedAt.
  ls_item_create-created_at = <fs_item>-CreatedAt.
  ls_item_create-created_by = <fs_item>-CreatedBy.

  get TIME STAMP FIELD data(lv_tmstmp).
  ls_item_create-local_last_changed = lv_tmstmp.


  APPEND ls_item_create TO lt_item_create.
  ENDLOOP.
  ENDLOOP.

  ENDMETHOD.

  METHOD Approve.

    DATA(lv_doc) = keys[ 1 ]-Docno.

    SELECT * FROM ztumi_header WHERE Docno = @lv_doc INTO TABLE @DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).
      ls_header_update-status       = 'Approved'.
      ls_header_update-docno        = ls_data-Docno.
      ls_header_update-company_code = ls_data-CompanyCode.
      ls_header_update-purchase_org = ls_data-PurchaseOrg.
      ls_header_update-currency     = ls_data-Currency.
      ls_header_update-supplier_no  = ls_data-SupplierNo.
      ls_header_update-changed_at   = ls_data-ChangedAt.
      ls_header_update-created_at   = ls_data-CreatedAt.
      ls_header_update-created_by   = ls_data-CreatedBy.

      get TIME STAMP FIELD data(lv_tmstmp).
      ls_header_update-local_last_changed = lv_tmstmp.

      INSERT CORRESPONDING #( ls_header_update ) INTO TABLE lt_header_update.

    ENDLOOP.
  ENDMETHOD.

  method get_instance_features.
    READ ENTITIES OF ztumi_header IN LOCAL MODE
    ENTITY hdr
    FIELDS ( Status ) with CORRESPONDING #( keys )
    RESULT DATA(lv_doc_result)
     FAILED failed.

  result =
    VALUE #( FOR ls_status IN lv_doc_result
      ( %key = ls_status-%key
        %features = VALUE #( %action-Approve = COND #( WHEN ls_status-status eq 'Approved' or ls_status-status eq 'Rejected'
                                                      THEN if_abap_behv=>fc-o-disabled
                                                      ELSE if_abap_behv=>fc-o-enabled )
                             %action-Reject = COND #( WHEN ls_status-status eq 'Approved' or ls_status-status eq 'Rejected'
                                                      THEN if_abap_behv=>fc-o-disabled
                                                      ELSE if_abap_behv=>fc-o-enabled )
       ) ) ).
  ENDMETHOD.


  METHOD Reject.
  DATA(lv_doc) = keys[ 1 ]-Docno.

    SELECT * FROM ztumi_header WHERE Docno = @lv_doc INTO TABLE @DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).
      ls_header_update-status       = 'Rejected'.
      ls_header_update-docno        = ls_data-Docno.
      ls_header_update-company_code = ls_data-CompanyCode.
      ls_header_update-purchase_org = ls_data-PurchaseOrg.
      ls_header_update-currency     = ls_data-Currency.
      ls_header_update-supplier_no  = ls_data-SupplierNo.
      ls_header_update-changed_at   = ls_data-ChangedAt.
      ls_header_update-created_at   = ls_data-CreatedAt.
      ls_header_update-created_by   = ls_data-CreatedBy.

      get TIME STAMP FIELD data(lv_tmstmp).
      ls_header_update-local_last_changed = lv_tmstmp.

      INSERT CORRESPONDING #( ls_header_update ) INTO TABLE lt_header_update.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.

PUBLIC SECTION.
CLASS-DATA:

      lt_item_delete TYPE STANDARD TABLE OF ztum_item WITH NON-UNIQUE DEFAULT KEY,
      ls_item_delete TYPE ztum_item,

      lt_item_update TYPE STANDARD TABLE OF ztum_item WITH NON-UNIQUE DEFAULT KEY,
      ls_item_update TYPE ztum_item.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE itm.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE itm.

    METHODS read FOR READ
      IMPORTING keys FOR READ itm RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ itm\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_itm IMPLEMENTATION.

  METHOD update.

  LOOP AT entities INTO DATA(entity).
  ENDLOOP.
  select SINGLE * from ztum_item where docno = @entity-Docno
  and item_no = @entity-ItemNo into @ls_item_update.

  if entity-%control-Docno is not INITIAL.
  ls_item_update-docno = entity-Docno.
  ENDIF.
  if entity-%control-ItemNo is not INITIAL.
  ls_item_update-item_no = entity-ItemNo.
  ENDIF.
  if entity-%control-Status is not INITIAL.
  ls_item_update-status = entity-Status.
  ENDIF.
  if entity-%control-Quantity is not INITIAL.
  ls_item_update-quantity = entity-Quantity.
  ENDIF.
  if entity-%control-Currency is not INITIAL.
  ls_item_update-currency = entity-Currency.
  ENDIF.
  if entity-%control-Amount is not INITIAL.
  ls_item_update-amount = entity-Amount.
  ENDIF.
  if entity-%control-TaxAmt is not INITIAL.
  ls_item_update-tax_amt = entity-TaxAmt.
  ENDIF.
  if entity-%control-ChangedAt is not INITIAL.
  ls_item_update-changed_at = entity-ChangedAt.
  ENDIF.
  if entity-%control-CreatedAt is not INITIAL.
  ls_item_update-created_at = entity-CreatedAt.
  ENDIF.
  if entity-%control-CreatedBy is not INITIAL.
  ls_item_update-created_by = entity-CreatedBy.
  ENDIF.

  get TIME STAMP FIELD data(lv_tmstmp).
  ls_item_update-local_last_changed = lv_tmstmp.

   INSERT CORRESPONDING #( entity ) INTO TABLE mapped-hdr.
   INSERT CORRESPONDING #( ls_item_update ) INTO TABLE lt_item_update.

  ENDMETHOD.

  METHOD delete.
  LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_del>).

        ls_item_delete-docno = <ls_del>-Docno.
        ls_item_delete-item_no = <ls_del>-ItemNo.
        INSERT CORRESPONDING #( ls_item_delete ) INTO TABLE lt_item_delete.
        ENDLOOP.
  ENDMETHOD.

  METHOD read.
  SELECT * from ztumi_item for all ENTRIES IN @keys where Docno = @keys-Docno AND ItemNo = @keys-ItemNo
  into CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZTUMI_HEADER DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZTUMI_HEADER IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

      IF lhc_hdr=>lt_header_create IS NOT INITIAL.
      MODIFY ztum_header FROM TABLE @lhc_hdr=>lt_header_create.
      ENDIF.

      IF lhc_hdr=>lt_header_update IS NOT INITIAL.
      MODIFY ztum_header FROM TABLE @lhc_hdr=>lt_header_update.
      ENDIF.

      IF lhc_hdr=>lt_header_delete IS NOT INITIAL.
      DELETE ztum_header FROM TABLE @lhc_hdr=>lt_header_delete.
      DELETE ztum_item FROM TABLE @lhc_hdr=>lt_header_delete.
      ENDIF.

      IF lhc_hdr=>lt_item_create IS NOT INITIAL.
      MODIFY ztum_item FROM TABLE @lhc_hdr=>lt_item_create.
      ENDIF.

      IF lhc_itm=>lt_item_delete IS NOT INITIAL.
      DELETE ztum_item FROM TABLE @lhc_itm=>lt_item_delete.
      ENDIF.

      IF lhc_itm=>lt_item_update IS NOT INITIAL.
      Modify ztum_item FROM TABLE @lhc_itm=>lt_item_update.
      ENDIF.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
