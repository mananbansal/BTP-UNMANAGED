@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection for header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZTUMC_HEADER as projection on ZTUMI_HEADER
{ 
    key Docno,
    Status,
    CompanyCode,
    Currency,
    SupplierNo,
    PurchaseOrg,
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_DEPARTMENT'
    @EndUserText.label: 'Department'
    virtual department : abap.string,
    ChangedAt,
    CreatedAt,
    CreatedBy,
    localLastChanged,
    _headerTf.remark,
    _headerTf.compname,
    /* Associations */
    _item : redirected to composition child ZTUMC_ITEM
}
