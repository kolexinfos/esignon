<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Import Namespace="Microsoft.SharePoint.ApplicationPages" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReviewerList.aspx.cs" Inherits="ESignon.Layouts.ESignon.ReviewerList" DynamicMasterPageFile="~masterurl/default.master" %>


<asp:Content ID="PageHead" ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
    <link href="jquery-ui.css" rel="stylesheet" type="text/css" />

</asp:Content>



<asp:Content ID="Main" ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <script type="text/javascript" src='<%=ResolveClientUrl("jquery.js")%>'></script>
    <script type="text/javascript" src='<%=ResolveClientUrl("jquery-ui.js")%>'></script>
    

    <script type ="text/javascript">

    function Test()
    {
      alert("ok");

    }

    function httpGetAsync(theUrl, callback) {
            var xmlHttp = new XMLHttpRequest();
            xmlHttp.onreadystatechange = function () {
                if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
                    callback(xmlHttp.responseText);
            }
            xmlHttp.open("GET", theUrl, true); // true for asynchronous 
            xmlHttp.send(null);
        }

     function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            //alert(decodeURIComponent(results[2].replace(/\+/g, " ")));

            return decodeURIComponent(results[2].replace(/\+/g, " "));
        }

        $(function () {
            $("#sortable").sortable();
            $("#sortable").disableSelection();
        });

        $(document).ready(function () {
            console.log("We are ready!!!!");

          
        })


        function AddSigner() {
            event.preventDefault();

            var signer = $('#ctl00_PlaceHolderMain_DropDownList1').find(":selected").text();
                //$('#DropDownList1').val();

            console.log(signer);

            $('#sortable').append('<li class="ui- state -default"><span class="ui- icon ui- icon - arrowthick - 2 - n - s"></span>' + signer + '</li>');

            $('#ctl00_PlaceHolderMain_DropDownList1').find(":selected").remove();
        }

        function GoToPreview() {
            event.preventDefault();
            var serverName = _spPageContextInfo.siteAbsoluteUrl;
            console.log('ServerName : ' + serverName);

            var mySelectedItems = getParameterByName("items");
            var currentListGUID = getParameterByName("list");

            var signers = '';

            $("#sortable").find('li').each(function () {
                console.log($(this).text());
                signers += $(this).text();
                signers += '|';
            })

            window.location.href = serverName + '/_layouts/15/ESignOn/ESignPreview.aspx?items=' + mySelectedItems + '&list=' + currentListGUID + '&signers=' + signers;

        }
       
    </script>
    
    
    <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="false" >
        
    </asp:DropDownList>

    <asp:Button ID="Button1" runat="server" Text="Add Signer"  OnClientClick="AddSigner()" />
    <asp:Button ID="Button2" runat="server" Text="Go To Preview"  OnClientClick="GoToPreview()" />

    <ul  id="sortable">

    </ul>
</asp:Content>

<asp:Content ID="PageTitle" ContentPlaceHolderID="PlaceHolderPageTitle" runat="server">
Reviewer List 
</asp:Content>

<asp:Content ID="PageTitleInTitleArea" ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server" >
Reviewer List Page
</asp:Content>
