CLASS zcl_totalamount DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_totalamount IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

  DATA: lt_itemData TYPE TABLE OF ztumc_item with DEFAULT KEY.
        lt_itemData = CORRESPONDING #( it_original_data ).

        loop AT lt_itemdata ASSIGNING FIELD-SYMBOL(<ls_itemdata>).

        <ls_itemdata>-totalAmount = ( <ls_itemdata>-Amount * <ls_itemdata>-Quantity ) + <ls_itemdata>-TaxAmt.
        <ls_itemdata>-DiscountedAmount =  <ls_itemdata>-totalAmount - (  ( <ls_itemdata>-totalAmount * 10 ) / 100 ).
        <ls_itemdata>-Saved = ( ( <ls_itemdata>-totalAmount - <ls_itemdata>-DiscountedAmount ) / <ls_itemdata>-totalAmount ) * 100 .

        ENDLOOP.

        ct_calculated_data = CORRESPONDING #( lt_itemdata ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
