 DBCC SHOWCONTIG (Sepet) --DBCC SHOWCONTIG command to see the density and the degree of fragmentation for an index for a table.
 /*
There are several ways to resolve index fragmentation.

- Drop and recreate the index.
- Use the DBCC DBREINDEX command.
- Use the DBCC INDEXDEFRAG command.

The first two ways hold locks against the system. Therefore, you should only drop and then recreate an index or use the DBCC DBREINDEX command when there are no users on the system.

You can use DBCC INDEXDEFRAG when your system is online because it does not lock resources.
*/
 DBCC INDEXDEFRAG (GulaylarOnlineDb, Grup);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, Cinsiyet);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, ParoIndirimLog);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, Roller);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, SiparisDetay);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, UrunOzellik);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, KB_Egitim_Dil);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, Favoriler);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, KB_Iletisim);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, UlkeSehir);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, Ilceler);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, Adresler);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, CardOdeme);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, Sepet);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, SatisNoktalarimiz);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, Magazalar);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, KisiselBilgilerim);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, KB_Egitim);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, TTNET);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, NoMail);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, EAN);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, HAberler);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, SehirFirsati);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, BankaHataKodlari);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, STATS2);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, InsertLink);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, InsertSeri);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, MailList);
 DBCC INDEXDEFRAG (GulaylarOnlineDb, Kupon);
   
 
 /*
 DBCC SHOWCONTIG scanning 'Sepet' table...
Table: 'Sepet' (1111675008); index ID: 1, database ID: 13
TABLE level scan performed.
- Pages Scanned................................: 319
- Extents Scanned..............................: 42
- Extent Switches..............................: 41
- Avg. Pages per Extent........................: 7.6
- Scan Density [Best Count:Actual Count].......: 95.24% [40:42]
- Logical Scan Fragmentation ..................: 0.63%
- Extent Scan Fragmentation ...................: 71.43%
- Avg. Bytes Free per Page.....................: 120.9
- Avg. Page Density (full).....................: 98.51%
 */
 /*
 DBCC SHOWCONTIG scanning 'KisiselBilgilerim' table...
Table: 'KisiselBilgilerim' (1483152329); index ID: 1, database ID: 13
TABLE level scan performed.
- Pages Scanned................................: 30
- Extents Scanned..............................: 6
- Extent Switches..............................: 5
- Avg. Pages per Extent........................: 5.0
- Scan Density [Best Count:Actual Count].......: 66.67% [4:6]
- Logical Scan Fragmentation ..................: 6.67%
- Extent Scan Fragmentation ...................: 66.67%
- Avg. Bytes Free per Page.....................: 267.0
- Avg. Page Density (full).....................: 96.70%
 */
 --KisiselBilgilerim
 /*
 TABLE level scan performed.
- Pages Scanned................................: 499
- Extents Scanned..............................: 64
- Extent Switches..............................: 63
- Avg. Pages per Extent........................: 7.8
- Scan Density [Best Count:Actual Count].......: 98.44% [63:64]
- Extent Scan Fragmentation ...................: 7.81%
- Avg. Bytes Free per Page.....................: 314.2
- Avg. Page Density (full).....................: 96.12%
 */
