CLASS zcl_department DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_department IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
  DATA: lt_headerData TYPE TABLE OF ztumc_header with DEFAULT KEY.
        lt_headerData = CORRESPONDING #( it_original_data ).

        loop AT lt_headerData ASSIGNING FIELD-SYMBOL(<ls_headerdata>).

      <ls_headerdata>-department = <ls_headerdata>-PurchaseOrg && '-' && <ls_headerdata>-SupplierNo.

        ENDLOOP.

        ct_calculated_data = CORRESPONDING #( lt_headerData ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
