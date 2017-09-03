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
      var listItemID = 0;
      var listname = getParameterByName("list");

      SP.SOD.executeFunc('SP.js', 'SP.ClientContext', function () {
          ctx = SP.ClientContext.get_current();
      });

      function retrieveAllListProperties() {
          event.preventDefault();
          console.log("Get Lists");

          // Get current web (comparable to SPWeb)
          web = ctx.get_web();

          //Retrive file
          var attachmentFolder = web.getFolderByServerRelativeUrl('Lists/' + listname + '/Attachments/' + listItemID);

          var attachmentFiles = attachmentFolder.get_files();

          //Load attachments
          ctx.load(attachmentFiles);

          ctx.executeQueryAsync(Function.createDelegate(this, onSuccess), Function.createDelegate(this, onFailure));

          function onSuccess(sender, args) {
              console.log('Success');

              var cnt = attachmentFiles.get_count();

              for (var itr = 0; itr < cnt; itr++) {
                  var fileName = attachmentFiles.itemAt(itr).get_name();

                  console.log(filename + ' : ' + attachmentFiles.itemAt(itr).get_serverRelativeUrl());
              }
          }

              function onFailure(sender, args) {

                  alert('failed to get list.Error:' + args.get_message());


              }

             
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
    <asp:TextBox ID="TextBox1" TextMode="multiline" Columns="50" Rows="5" runat="server"></asp:TextBox>
    <asp:Button ID="Button1" runat="server" Text="Get List"  OnClientClick="retrieveAllListProperties()" />

    
</asp:Content>



<asp:Content ID="PageTitle" ContentPlaceHolderID="PlaceHolderPageTitle" runat="server">
Application Page
</asp:Content>

<asp:Content ID="PageTitleInTitleArea" ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server" >
My Application Page
</asp:Content>
