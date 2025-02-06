@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZTUMI_HEADER as select from ztum_header
composition [0..*] of ZTUMI_ITEM  as _item
association [0..1] to ZTUMTFI_HEADER_ as _headerTf
on $projection.Docno = _headerTf.docno
{
    key docno as Docno,
    status as Status,
    company_code as CompanyCode,
    currency as Currency,
    supplier_no as SupplierNo,
    purchase_org as PurchaseOrg,
    changed_at as ChangedAt,
    created_at as CreatedAt,
    created_by as CreatedBy,
    local_last_changed as localLastChanged,
    _item,
    _headerTf
}
