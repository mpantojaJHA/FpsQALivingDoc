# FpsQALivingDoc

## Tile Updated Dates (Home Page)

The home page tiles in `index.html` display their update date from each tile's `data-updated` attribute.

### Where to update

- File: `index.html`
- Element: each `<a class="btn" ...>` in the `.button-grid`
- Attribute format: `data-updated="YYYY-MM-DD"`

Example:

```html
<a href="Livingdoc/ALM/LivingDocALM.html" class="btn" data-updated="2026-01-30">
```

### Quick refresh from local file timestamps (PowerShell)

Run from the repo root to view current dates for linked docs:

```powershell
$files=@('Livingdoc/ALM/LivingDocALM.html','Livingdoc/CECL/LivingDocCECL.html','Livingdoc/CustomerPricing/LivingDocPricing.html','Livingdoc/CustomerProfitability/LivingDocProfitability.html','Livingdoc/Forecasting/LivingDocForecasting.html','Livingdoc/ReconciliationSummary/LivingDocReconciliationSummary.html','Livingdoc/Allocations/LivingDocAllocations.html','Livingdoc/Reporting/LivingDocReporting.html','Livingdoc/HomePageWidgets/LivingDocHome.html','Livingdoc/Notifications/LivingDocNotifications.html','Livingdoc/DailyDashboard/LivingDocDailyDashboard.html','Livingdoc/LiquidityRisk/LivingDocLiquidityRisk.html'); foreach($f in $files){$d=(Get-Item $f).LastWriteTime.ToString('yyyy-MM-dd'); Write-Output "$f|$d"}
```

Copy the resulting dates into the corresponding `data-updated` values in `index.html`.

### Helper script (preview or auto-apply)

You can use `docs/refresh-tile-dates.ps1` to generate updated tile opening tags, or apply the changes directly.

Preview updated tile tags:

```powershell
pwsh -File .\docs\refresh-tile-dates.ps1
```

Apply directly to `index.html`:

```powershell
pwsh -File .\docs\refresh-tile-dates.ps1 -Apply
```

Check only (no file changes, exits non-zero if stale):

```powershell
pwsh -File .\docs\refresh-tile-dates.ps1 -Check
```

### Run automatically on commit (Git hook)

This repo includes a versioned pre-commit hook at `.githooks/pre-commit`.

Enable it once per local clone:

```powershell
git config core.hooksPath .githooks
```

After this, each `git commit` will:

- run `docs/refresh-tile-dates.ps1 -Apply`
- stage `index.html` automatically

This repo also includes `.githooks/pre-push`, which runs `docs/refresh-tile-dates.ps1 -Check` and blocks push if tile dates are stale.