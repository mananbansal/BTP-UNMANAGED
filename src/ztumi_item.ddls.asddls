@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZTUMI_ITEM as select from ztum_item
association to parent ZTUMI_HEADER as _header on $projection.Docno= _header.Docno
{
    key docno as Docno,
    key item_no as ItemNo,
    status as Status,
    currency as Currency,
    quantity as Quantity,
    @Semantics.amount.currencyCode: 'Currency'
    amount as Amount,
    @Semantics.amount.currencyCode: 'Currency'
    tax_amt as TaxAmt,
    changed_at as ChangedAt,
    created_at as CreatedAt,
    created_by as CreatedBy,
    local_last_changed as localLastChanged,
    _header
}
