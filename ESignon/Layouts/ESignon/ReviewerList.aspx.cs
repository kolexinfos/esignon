using System;
using Microsoft.SharePoint;
using Microsoft.SharePoint.WebControls;
using System.Diagnostics;
using System.Net;
using System.IO;
using System.Text;
using System.Collections.Generic;
using Newtonsoft.Json;
using DocumentFormat.OpenXml.Packaging;
using OpenXmlPowerTools;
using System.Xml.Linq;
using Microsoft.SharePoint.Client;
using System.Drawing.Imaging;

namespace ESignon.Layouts.ESignon
{
    public partial class ReviewerList : LayoutsPageBase
    {
        string selectedRows;
        string selectedList;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                selectedRows = Request.QueryString["items"];
                selectedList = Request.QueryString["list"];

                Debug.Write(selectedRows);
                Debug.Write(selectedList);

                WebRequest request = WebRequest.Create("http://localhost/boi/api/DocumenSigning/GetSigners");
                request.Method = "GET";
                WebResponse response = request.GetResponse();

                Stream ReceiveStream = response.GetResponseStream();

                Encoding encode = System.Text.Encoding.GetEncoding("utf-8");

                StreamReader readStream = new StreamReader(ReceiveStream, encode);

                Char[] read = new Char[256];

                int count = readStream.Read(read, 0, 256);

                string responseText = "";

                while (count > 0)
                {
                    String str = new string(read, 0, count);
                    count = readStream.Read(read, 0, 256);

                    responseText += str;
                }

                readStream.Close();
                response.Close();

                List<Signer> signers = JsonConvert.DeserializeObject<List<Signer>>(responseText);

                foreach (var signer in signers)
                {
                    string fullname = signer.firstname + signer.lastname;
                    DropDownList1.Items.Insert(0, fullname);
                }

                GetDocuments();
            }

            //TextArea1.Text = response.
        }

        public void Selection_Change(Object sender, EventArgs e)
        {
            

            

        }

        protected void Button1_Click(object sender, EventArgs e)
        {

            //TextArea1.Text += DropDownList1.SelectedItem.Text;
            DropDownList1.Items.Remove(DropDownList1.SelectedItem.Text);

        }

        protected void GoToPreview(object sender, EventArgs e)
        {

            //SPSite oSiteCollection = SPContext.Current.Site;
            //SPList oList = oSiteCollection.AllWebs["Site_Name"].Lists["List_Name"];
            

            Server.Transfer("ESignPreview.aspx?" + Request.QueryString);
        }

        


         public void GetDocuments()
            {
                try
                {
                    int startListID = 1;
                    Console.WriteLine("Enter Starting List ID");


                String siteUrl = SPContext.Current.Web.Url;
                    //http://siteaction.net/sites/teamsite";
                    String listName = selectedList;
                    NetworkCredential credentials =
                                new NetworkCredential("sp_setup", "Funnys514000", "contoso");

                    using (ClientContext clientContext = new ClientContext(siteUrl))
                    {
                        Console.WriteLine("Started Attachment Download " + siteUrl);
                        
                        clientContext.Credentials = credentials;

                        //Get the Site Collection
                        Site oSite = clientContext.Site;
                        clientContext.Load(oSite);
                        clientContext.ExecuteQuery();

                        // Get the Web
                        Web oWeb = clientContext.Web;
                        clientContext.Load(oWeb);
                        clientContext.ExecuteQuery();

                        CamlQuery query = new CamlQuery();
                        query.ViewXml = @"";

                        List oList = clientContext.Web.Lists.GetByTitle(listName);
                        clientContext.Load(oList);
                        clientContext.ExecuteQuery();

                        ListItemCollection items = oList.GetItems(query);
                        clientContext.Load(items);
                        clientContext.ExecuteQuery();

                        foreach (ListItem listItem in items)
                        {
                            if (Int32.Parse(listItem["ID"].ToString()) >= startListID)
                            {

                                Console.WriteLine("Process Attachments for ID " +
                                      listItem["ID"].ToString());

                                Folder folder =
                                      oWeb.GetFolderByServerRelativeUrl(oSite.Url +
                                      "/Lists/" + listName + "/Attachments/" +
                      
                                      listItem["ID"]);

                                clientContext.Load(folder);

                                try
                                {
                                    clientContext.ExecuteQuery();
                                }
                                catch (ServerException ex)
                                {
                                    
                                    Console.WriteLine(ex.Message);
                                    
                                    Console.WriteLine("No Attachment for ID " + listItem["ID"].ToString());
                                }

                                FileCollection attachments = folder.Files;
                                clientContext.Load(attachments);
                                clientContext.ExecuteQuery();

                                foreach (Microsoft.SharePoint.Client.File oFile in folder.Files)
                                {
                                    

                                    Console.WriteLine("Found Attachment for ID " +
                                          listItem["ID"].ToString());

                                    FileInfo myFileinfo = new FileInfo(oFile.Name);
                                    WebClient client1 = new WebClient();
                                    client1.Credentials = credentials;

                                    

                                    Console.WriteLine("Downloading " +
                                          oFile.ServerRelativeUrl);

                                    byte[] fileContents =
                                          client1.DownloadData("http://esignon-sp:11708" +
                                          oFile.ServerRelativeUrl);

                                XElement html = ConvertToHTML(fileContents);

                                    //FileStream fStream = new FileStream(@"C:Temp\" +
                                    //      oFile.Name, FileMode.Create);

                                    //fStream.Write(fileContents, 0, fileContents.Length);
                                    //fStream.Close();
                                }
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    
                    Console.WriteLine(e.Message);
                    Console.WriteLine(e.StackTrace);
                }
            }

        public XElement ConvertToHTML(byte[] byteArray)
        {
            XElement html;

            using (MemoryStream memoryStream = new MemoryStream())
            {
                memoryStream.Write(byteArray, 0, byteArray.Length);
                using (WordprocessingDocument doc = WordprocessingDocument.Open(memoryStream, true))
                {
                    int imageCounter = 0;
                    HtmlConverterSettings settings = new HtmlConverterSettings()
                    {
                        PageTitle = "My Page Title",
                        FabricateCssClasses = true,
                        AdditionalCss = "",
                        GeneralCss = "",
                        CssClassPrefix = "",
                        RestrictToSupportedLanguages = false,
                        RestrictToSupportedNumberingFormats = false,
                        ImageHandler = imageInfo =>
                        {
                            DirectoryInfo localDirInfo = new DirectoryInfo("img");
                            if (!localDirInfo.Exists)
                                localDirInfo.Create();
                            ++imageCounter;
                            string extension = imageInfo.ContentType.Split('/')[1].ToLower();
                            ImageFormat imageFormat = null;
                            if (extension == "png")
                            {
                                extension = "gif";
                                imageFormat = ImageFormat.Gif;
                            }
                            else if (extension == "gif")
                                imageFormat = ImageFormat.Gif;
                            else if (extension == "bmp")
                                imageFormat = ImageFormat.Bmp;
                            else if (extension == "jpeg")
                                imageFormat = ImageFormat.Jpeg;
                            else if (extension == "tiff")
                            {
                                extension = "gif";
                                imageFormat = ImageFormat.Gif;
                            }
                            else if (extension == "x-wmf")
                            {
                                extension = "wmf";
                                imageFormat = ImageFormat.Wmf;
                            }
                            if (imageFormat == null)
                                return null;

                            string imageFileName = "img/image" +
                                imageCounter.ToString() + "." + extension;
                            try
                            {
                                imageInfo.Bitmap.Save(imageFileName, imageFormat);
                            }
                            catch (System.Runtime.InteropServices.ExternalException)
                            {
                                return null;
                            }
                            XElement img = new XElement(Xhtml.img,
                                new XAttribute(NoNamespace.src, imageFileName),
                                imageInfo.ImgStyleAttribute,
                                imageInfo.AltText != null ?
                                    new XAttribute(NoNamespace.alt, imageInfo.AltText) : null);
                            return img;
                        }
                    };
                    html = HtmlConverter.ConvertToHtml(doc, settings);
                    //System.IO.File.WriteAllText("kk.html", html.ToStringNewLineOnAttributes());
                };
            }
            return html;
        }
    }

   
}
