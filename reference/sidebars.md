# Sidebar functions

These functions content the UI code for the main sidebar in the
interface of MagellanNTK

## Usage

``` r
Insert_User_Sidebar()
```

## Value

Shiny UI component

## Examples

``` r
Insert_User_Sidebar()
#> <ul class="nav nav-pills nav-sidebar flex-column sidebar-menu nav-child-indent" data-widget="treeview" role="menu" data-accordion="true">
#>   <li class="nav-item">
#>     <a class="nav-link" id="tab-Home" href="#" data-target="#shiny-tab-Home" data-toggle="tab" data-value="Home">
#>       <i class="fas fa-house nav-icon" role="presentation" aria-label="house icon"></i>
#>       <p>
#>         <p class="sidebarMenuItem">Home</p>
#>       </p>
#>     </a>
#>   </li>
#>   <li class="nav-item has-treeview">
#>     <a href="#" class="nav-link">
#>       <i class="fas fa-house nav-icon" role="presentation" aria-label="house icon"></i>
#>       <p>
#>         <p class="sidebarMenuItem">Dataset</p>
#>         <i class="right fas fa-angle-left"></i>
#>       </p>
#>     </a>
#>     <ul class="nav nav-treeview" data-expanded="&lt;pclass=&quot;sidebarMenuItem&quot;&gt;Dataset&lt;/p&gt;">
#>       <li class="nav-item">
#>         <a class="nav-link treeview-link" id="tab-openDataset" href="#" data-target="#shiny-tab-openDataset" data-toggle="tab" data-value="openDataset">
#>           <i class="fas fa-gear" role="presentation" aria-label="gear icon" cl="fas fa-gear nav-icon"></i>
#>           <p>
#>             <p class="sidebarMenuSubItem">Open file</p>
#>           </p>
#>         </a>
#>       </li>
#>       <li class="nav-item">
#>         <a class="nav-link treeview-link" id="tab-convertDataset" href="#" data-target="#shiny-tab-convertDataset" data-toggle="tab" data-value="convertDataset">
#>           <i class="fas fa-gear" role="presentation" aria-label="gear icon" cl="fas fa-gear nav-icon"></i>
#>           <p>
#>             <p class="sidebarMenuSubItem">Import</p>
#>           </p>
#>         </a>
#>       </li>
#>       <li class="nav-item">
#>         <a class="nav-link treeview-link" id="tab-SaveAs" href="#" data-target="#shiny-tab-SaveAs" data-toggle="tab" data-value="SaveAs">
#>           <i class="fas fa-gear" role="presentation" aria-label="gear icon" cl="fas fa-gear nav-icon"></i>
#>           <p>
#>             <p class="sidebarMenuSubItem">Save As</p>
#>           </p>
#>         </a>
#>       </li>
#>     </ul>
#>   </li>
#>   <li class="nav-item has-treeview">
#>     <a href="#" class="nav-link">
#>       <i class="fas fa-house nav-icon" role="presentation" aria-label="house icon"></i>
#>       <p>
#>         <p class="sidebarMenuItem">Workflow</p>
#>         <i class="right fas fa-angle-left"></i>
#>       </p>
#>     </a>
#>     <ul class="nav nav-treeview" data-expanded="&lt;pclass=&quot;sidebarMenuItem&quot;&gt;Workflow&lt;/p&gt;">
#>       <li class="nav-item">
#>         <a class="nav-link treeview-link" id="tab-workflow" href="#" data-target="#shiny-tab-workflow" data-toggle="tab" data-value="workflow">
#>           <i class="fas fa-gear" role="presentation" aria-label="gear icon" cl="fas fa-gear nav-icon"></i>
#>           <p>
#>             <p class="sidebarMenuSubItem">Run</p>
#>           </p>
#>         </a>
#>       </li>
#>       <li class="nav-item">
#>         <a class="nav-link treeview-link" id="tab-Manual" href="#" data-target="#shiny-tab-Manual" data-toggle="tab" data-value="Manual">
#>           <i class="fas fa-gear" role="presentation" aria-label="gear icon" cl="fas fa-gear nav-icon"></i>
#>           <p>
#>             <p class="sidebarMenuSubItem">Manual</p>
#>           </p>
#>         </a>
#>       </li>
#>       <li class="nav-item">
#>         <a class="nav-link treeview-link" id="tab-faq" href="#" data-target="#shiny-tab-faq" data-toggle="tab" data-value="faq">
#>           <i class="fas fa-gear" role="presentation" aria-label="gear icon" cl="fas fa-gear nav-icon"></i>
#>           <p>
#>             <p class="sidebarMenuSubItem">FAQ</p>
#>           </p>
#>         </a>
#>       </li>
#>       <li class="nav-item">
#>         <a class="nav-link treeview-link" id="tab-releaseNotes" href="#" data-target="#shiny-tab-releaseNotes" data-toggle="tab" data-value="releaseNotes">
#>           <i class="fas fa-gear" role="presentation" aria-label="gear icon" cl="fas fa-gear nav-icon"></i>
#>           <p>
#>             <p class="sidebarMenuSubItem">Release Notes</p>
#>           </p>
#>         </a>
#>       </li>
#>     </ul>
#>   </li>
#>   <div id="tabs_289892295" class="sidebarMenuSelectedTabItem" data-value="null"></div>
#> </ul>
```
