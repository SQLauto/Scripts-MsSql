CREATE NONCLUSTERED INDEX IX_Urunler_01 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [AltSinifAdi], [Aktif]);
CREATE NONCLUSTERED INDEX IX_Urunler_02 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi],[Aktif],[KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_03 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi],[AltSinifAdi], [Aktif],[KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_04 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi]);
CREATE NONCLUSTERED INDEX IX_Urunler_05 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif]);
CREATE NONCLUSTERED INDEX IX_Urunler_06 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([CinsiyetId]);
CREATE NONCLUSTERED INDEX IX_Urunler_07 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Outlet]);
CREATE NONCLUSTERED INDEX IX_Urunler_08 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_09 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([UrunModelNo]);
CREATE NONCLUSTERED INDEX IX_Urunler_11 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([ReferrerId]);
CREATE NONCLUSTERED INDEX IX_Urunler_12 ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([OzellikId]);
CREATE NONCLUSTERED INDEX IX_Urunler_13 ON [GulaylarOnlineDb].[dbo].[Sepet] ([UyeID], [NewUyeID]);
CREATE NONCLUSTERED INDEX IX_Urunler_14 ON [GulaylarOnlineDb].[dbo].[Sepet] ([NewUyeID]);
CREATE NONCLUSTERED INDEX IX_Urunler_15 ON [GulaylarOnlineDb].[dbo].[Sepet] ([UrunSeriNo], [NewUyeID]);
CREATE NONCLUSTERED INDEX IX_Uye_01 ON [GulaylarOnlineDb].[dbo].[Uye] ([UyeID],[ReferrerId]);
CREATE NONCLUSTERED INDEX IX_Uye_02 ON [GulaylarOnlineDb].[dbo].[Uye] ([ReferrerId]);





CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [AnnelerGunu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [BabalarGunu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [CinsiyetId], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [collection]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [KampanyaKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [OzellikID], [CinsiyetId]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [OzellikID], [KurKodu], [TasliTassiz]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [OzellikID], [TasliTassiz]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [Yilbasi]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Aktif], [YilDonumu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [AltSinifAdi], [Aktif], [CinsiyetId]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [AltSinifAdi], [Aktif], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [AltSinifAdi], [Aktif], [OzellikID], [CinsiyetId]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [AltSinifAdi], [Aktif], [OzellikID], [CinsiyetId], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [AltSinifAdi], [Aktif], [OzellikID], [KurKodu], [TasliTassiz]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [AltSinifAdi], [Aktif], [OzellikID], [TasliTassiz]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [AltSinifAdi], [Outlet], [Aktif]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Outlet], [Aktif], [OzellikID], [TasliTassiz]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [Outlet], [Aktif], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SinifAdi], [SevgililerGunu], [Aktif], [OzellikID], [TasliTassiz]);


CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [AnnelerGunu], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [AnnelerGunu], [OzellikID]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [BabalarGunu], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [BabalarGunu], [OzellikID], [TasliTassiz]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [CinsiyetId], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [collection]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [DogumGunu], [OzellikID]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [Dugun], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [KampanyaKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [KurKodu], [collection]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [KurKodu], [KampanyaKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [OzellikID], [CinsiyetId]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [OzellikID], [collection]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [OzellikID], [TasliTassiz], [collection]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [Soz], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [Yilbasi], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [Yilbasi], [OzellikID]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Aktif], [YilDonumu], [OzellikID]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([AltSinifAdi], [Aktif], [CinsiyetId]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([AltSinifAdi], [Aktif], [OzellikID], [TasliTassiz]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Evlilik], [Aktif], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Evlilik], [Aktif], [OzellikID]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Hediyelik], [Aktif], [OzellikID]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Klasik], [Aktif], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Klasik], [Aktif], [OzellikID]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([NewUyeID]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Outlet], [Aktif], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([Outlet], [Aktif], [OzellikID], [TasliTassiz]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([ReferrerId]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SevgililerGunu], [Aktif], [KurKodu]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([SevgililerGunu], [Aktif], [OzellikID], [TasliTassiz]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([UrunModelNo], [Aktif]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([UrunSeriNo], [NewUyeID]);
CREATE NONCLUSTERED INDEX IX_Urunler_ ON [GulaylarOnlineDb].[dbo].[Urunler_Temp] ([UyeID], [NewUyeID]);