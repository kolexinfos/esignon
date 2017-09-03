<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Import Namespace="Microsoft.SharePoint.ApplicationPages" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ESignPreview.aspx.cs" Inherits="ESignon.Layouts.ESignPreview" DynamicMasterPageFile="~masterurl/default.master" %>

<asp:Content ID="PageHead" ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">

</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="PlaceHolderMain" runat="server">
  <script type ="text/javascript">

      var siteUrl = '/';
      var _ctx;
      var itemId = 2;
      var targetListItem;

      SP.SOD.executeFunc('SP.js', 'SP.ClientContext', function () {
          _ctx = SP.ClientContext.get_current();
      });

      function retrieveAllListProperties() {
          event.preventDefault();
          console.log("Get Lists");

          var currentListGUID = getParameterByName("list");

          //var clientContext = new SP.ClientContext(siteUrl);
          var oWebsite = _ctx.get_web();
          this.collList = oWebsite.get_lists().getById(currentListGUID);
          targetListItem = collList.getItemById(itemId);

          _ctx.load(targetListItem);
          _ctx.load(targetListItem.get_attachmentFiles());

          _ctx.executeQueryAsync(Function.createDelegate(this, this.onQuerySucceeded), Function.createDelegate(this, this.onQueryFailed));
      }

      function onQuerySucceeded() {
          console.log(targetListItem);
          var item = targetListItem;
          var total = item.get_attachmentFiles().get_count();
          if (total > 0) {
              console.log(total + " file attachments");
          }  

          console.log(item);
      }

      function onQueryFailed(sender, args) {
          console.log(('Request failed. \nError: ' + args.get_message() + '\nStackTrace: ' + args.get_stackTrace()));
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

  </script>

    <asp:Button ID="Button1" runat="server" Text="Get List"  OnClientClick="retrieveAllListProperties()" />


</asp:Content>



<asp:Content ID="PageTitle" ContentPlaceHolderID="PlaceHolderPageTitle" runat="server">
Application Page
</asp:Content>

<asp:Content ID="PageTitleInTitleArea" ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server" >
My Application Page
</asp:Content>
