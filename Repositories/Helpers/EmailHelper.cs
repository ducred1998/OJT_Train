﻿using MimeKit;
using MimeKit.Text;
namespace Repositories.Helpers
{
	public class EmailHelper
	{
		private static EmailHelper? instance;
		public static EmailHelper Instance
		{
			get { if (instance == null) instance = new EmailHelper(); return EmailHelper.instance; }
			private set { EmailHelper.instance = value; }
		}
		public string BodyForgotMail(string? email,string password)
		{
			return "<!DOCTYPE html>\r\n<html>\r\n\r\n<head>\r\n\r\n    <meta charset=\"utf-8\">\r\n    <meta http-equiv=\"x-ua-compatible\" content=\"ie=edge\">\r\n    <title>Email Confirmation</title>\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\r\n    <style type=\"text/css\">\r\n        @media screen {\r\n            @font-face {\r\n                font-family: 'Source Sans Pro';\r\n                font-style: normal;\r\n                font-weight: 400;\r\n                src: local('Source Sans Pro Regular'), local('SourceSansPro-Regular'), url(https://fonts.gstatic.com/s/sourcesanspro/v10/ODelI1aHBYDBqgeIAH2zlBM0YzuT7MdOe03otPbuUS0.woff) format('woff');\r\n            }\r\n\r\n            @font-face {\r\n                font-family: 'Source Sans Pro';\r\n                font-style: normal;\r\n                font-weight: 700;\r\n                src: local('Source Sans Pro Bold'), local('SourceSansPro-Bold'), url(https://fonts.gstatic.com/s/sourcesanspro/v10/toadOcfmlt9b38dHJxOBGFkQc6VGVFSmCnC_l7QZG60.woff) format('woff');\r\n            }\r\n        }\r\n\r\n        body,\r\n        table,\r\n        td,\r\n        a {\r\n            -ms-text-size-adjust: 100%;\r\n            -webkit-text-size-adjust: 100%;\r\n        }\r\n\r\n        table,\r\n        td {\r\n            mso-table-rspace: 0pt;\r\n            mso-table-lspace: 0pt;\r\n        }\r\n\r\n        img {\r\n            -ms-interpolation-mode: bicubic;\r\n        }\r\n\r\n        a[x-apple-data-detectors] {\r\n            font-family: inherit !important;\r\n            font-size: inherit !important;\r\n            font-weight: inherit !important;\r\n            line-height: inherit !important;\r\n            color: inherit !important;\r\n            text-decoration: none !important;\r\n        }\r\n\r\n        div[style*=\"margin: 16px 0;\"] {\r\n            margin: 0 !important;\r\n        }\r\n\r\n        body {\r\n            width: 100% !important;\r\n            height: 100% !important;\r\n            padding: 0 !important;\r\n            margin: 0 !important;\r\n        }\r\n\r\n        table {\r\n            border-collapse: collapse !important;\r\n        }\r\n\r\n        button {\r\n            background-color: #1a82e2;\r\n            cursor: pointer;\r\n        }\r\n        button:hover{\r\n            background-color: #06294983;\r\n        }\r\n        img {\r\n            height: auto;\r\n            line-height: 100%;\r\n            text-decoration: none;\r\n            border: 0;\r\n            outline: none;\r\n        }\r\n    </style>\r\n\r\n</head>\r\n\r\n<body style=\"background-color: #e9ecef;\">\r\n    <div class=\"preheader\" style=\"display: none; max-width: 0; max-height: 0; overflow: hidden; font-size: 1px; line-height: 1px; color: #fff; opacity: 0;\">\r\n    </div>\r\n    <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\r\n        <tr>\r\n            <td align=\"center\" bgcolor=\"#e9ecef\">\r\n                <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px;\">\r\n                    <tr>\r\n                        <td align=\"left\" bgcolor=\"#ffffff\" style=\"padding: 36px 24px 0; border-top: 3px solid #d4dadf;\">\r\n                            <h1 style=\"margin: 0; font-size: 32px; font-weight: 700; letter-spacing: -1px; line-height: 48px;text-align: center;\">FORGOT PASSWORD</h1>\r\n                        </td>\r\n                    </tr>\r\n                </table>\r\n            </td>\r\n        </tr>\r\n        <tr>\r\n            <td align=\"center\" bgcolor=\"#e9ecef\">\r\n                <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px;\">\r\n                    <tr>\r\n                        <td align=\"left\" bgcolor=\"#ffffff\" style=\"padding: 24px; font-size: 16px; line-height: 24px;\">\r\n                            <p style=\"margin: 0;\"> " + "Chào bạn" + ", <br />\r\n                            Chúng tôi nhận được yêu cầu mật khẩu mới từ bạn, vui lòng đăng nhập bằng mật khẩu mới này:<br /><br />\r\n                          Mật khẩu mới: <strong>" + password + "</strong><br /><br />\r\n                                      Cảm ơn bạn đã dành thời gian để tìm kiếm sản phẩm ở trang web chúng tôi!Chúc bạn một ngày tốt lành!\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td align=\"left\" bgcolor=\"#ffffff\">\r\n                            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">\r\n                                <tr>\r\n                                    <td align=\"center\" bgcolor=\"#ffffff\" style=\"padding: 12px;\">\r\n                                        <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n                                            <tr>\r\n                                                <td align=\"center\" bgcolor=\"#1a82e2\" style=\"border-radius: 6px;\">\r\n                                                    \r\n                                                </td>\r\n                                            </tr>\r\n                                        </table>\r\n                                    </td>\r\n                                </tr>\r\n                            </table>\r\n                        </td>\r\n                    </tr>\r\n                    <tr>\r\n                        <td align=\"left\" bgcolor=\"#ffffff\"\r\n                            style=\"padding: 24px; font-size: 16px; line-height: 24px; border-bottom: 3px solid #d4dadf\">\r\n                            <p style=\"margin: 0;\"><br></p>\r\n                        </td>\r\n                    </tr>\r\n                </table>\r\n            </td>\r\n        </tr>\r\n    </table>\r\n</body>\r\n<script>\r\n    function onClick(){\r\n        navigator.clipboard.writeText(\"" + password + "\");\r\n    }\r\n</script>\r\n</html>>";
		}

		public async Task<bool> SendMail(string mail,string password)
		{
			string text= EmailHelper.Instance.BodyForgotMail(mail,password);
			var email = new MimeMessage();
			email.From.Add(MailboxAddress.Parse("jira.service.fpt@gmail.com"));
			email.To.Add(MailboxAddress.Parse(mail));
			email.Subject = "IPHONE COMFIRMED ACCOUNT";
			email.Body = new TextPart(TextFormat.Html)
			{
				Text = text
			};
			var smtp = new MailKit.Net.Smtp.SmtpClient();
			await smtp.ConnectAsync("smtp.gmail.com", 587, false);
			await smtp.AuthenticateAsync("jira.service.fpt@gmail.com", "hcjizzxjmyobukzt");
			await smtp.SendAsync(email);
			await smtp.DisconnectAsync(true);
			return true;
		}
	}
}
