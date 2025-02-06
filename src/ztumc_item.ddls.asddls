@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection for Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZTUMC_ITEM as projection on ZTUMI_ITEM
{
    key Docno,
    key ItemNo,
    Status,
    Currency,
    Quantity,
    @Semantics.amount.currencyCode: 'Currency'
    Amount,
    @Semantics.amount.currencyCode: 'Currency'
    TaxAmt,
    ChangedAt,
    CreatedAt,
    CreatedBy,
    localLastChanged,
    
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_TOTALAMOUNT'
    @EndUserText.label: 'Total Amount'
    virtual totalAmount : abap.dec( 10, 2 ),
    
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_TOTALAMOUNT'
    @EndUserText.label: 'Discounted Amount'
    virtual DiscountedAmount : abap.dec( 10, 2 ),
    
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_TOTALAMOUNT'
    @EndUserText.label: 'Saved (in %)'
    virtual Saved : abap.dec( 10, 2 ),
    /* Associations */
    _header: redirected to parent ZTUMC_HEADER
}
