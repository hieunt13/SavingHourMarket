-- Satus: enable(1), disable(0)
SET @enable = 1;
SET @disable = 0;

-- Gender: Female(1), Male(0)
SET @female = 1;
SET @male = 0;

-- System status: Active(1), Maintaining(0)
SET @systemActive = 1;
SET @SystemMaintaining = 0;

-- Order status:
SET @processing = 0;
SET @packaging = 1;
SET @packaged = 2;
SET @delivering = 3;
SET @success = 4;
SET @fail = 5;
SET @cancel = 6;

-- Order deliver date
SET @orderDateBatchingForGroup = DATE_FORMAT((CURDATE() + INTERVAL 1 DAY),'%Y-%m-%d');
SET @orderDateForBatchGroup = DATE_FORMAT((CURDATE() + INTERVAL 1 DAY),'%Y-%m-%d');
SET @orderDateForOrderGroup = DATE_FORMAT((CURDATE() + INTERVAL 3 DAY),'%Y-%m-%d');
SET @orderDateForFirstOrderGroupForAssignDeliver = DATE_FORMAT((CURDATE() + INTERVAL 1 DAY),'%Y-%m-%d');
SET @orderDateForSecondOrderGroupForAssignDeliver = DATE_FORMAT((CURDATE() + INTERVAL 1 DAY),'%Y-%m-%d');
SET @orderDateForThirdOrderGroupForAssignDeliver = DATE_FORMAT((CURDATE() + INTERVAL 1 DAY),'%Y-%m-%d');
SET @orderDateForOrderSingleForProcessingStatus = DATE_FORMAT((CURDATE() + INTERVAL 4 DAY),'%Y-%m-%d');
SET @orderDateForOrderSingleForDeliveringStatus = DATE_FORMAT((CURDATE()),'%Y-%m-%d');
SET @orderDateForOrderCancel = DATE_FORMAT((CURDATE() + INTERVAL 3 DAY),'%Y-%m-%d');

-- Order create date
SET @orderCreateDateBatchingForGroup =  CONCAT(DATE_FORMAT((CURDATE()),'%Y-%m-%d'), " ", DATE_FORMAT((CURTIME()),'%T'));
SET @orderCreateDateForBatchGroup =  CONCAT(DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%Y-%m-%d'), " ", DATE_FORMAT((CURTIME()),'%T'));

SET @orderCreateDateForOrderGroupHaveDeliverer = CONCAT(DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%Y-%m-%d'), " ", DATE_FORMAT((CURTIME()),'%T'));
SET @orderCreateDateForOrderGroupForProcessingOrder = CONCAT(DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%Y-%m-%d'), " ", DATE_FORMAT((CURTIME()),'%T'));
SET @orderCreateDateForOrderGroupForPackingOrder = CONCAT(DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%Y-%m-%d'), " ", DATE_FORMAT((CURTIME()),'%T'));
SET @orderCreateDateForOrderGroupForPackagedOrder = CONCAT(DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%Y-%m-%d'), " ", DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 3 HOUR), '%T'));
SET @orderCreateDateForOrderGroupHaveDelivererForNewProcessingOrder = CONCAT(DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%Y-%m-%d'), " ", DATE_FORMAT((CURTIME()),'%T'));
SET @orderCreateDateForOrderSingleForProcessingStatus = CONCAT(DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%Y-%m-%d'), " ", DATE_FORMAT((CURTIME()),'%T'));
SET @orderCreateDateForOrderSingleForDeliveringStatus = CONCAT(DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%Y-%m-%d'), " ", DATE_FORMAT((CURTIME()),'%T'));
SET @orderCreateDateForOrderCancel = CONCAT(DATE_FORMAT((CURDATE()),'%Y-%m-%d'), " ", DATE_FORMAT((CURTIME()),'%T'));
-- Payment method: COD(0), VNPay(1)
SET @cod = 0;
SET @vnpay = 1;

-- Delivery method: Pickup point(0), Door-to-Door (1)
SET @PickupPoint = 0;
SET @DoorToDoor = 1;
SET @All = 2;

-- Payment status: unpaid(0), paid(1)
SET @unpaid = 0;
SET @paid = 1;

-- feedback status:
SET @processingFeeback = 0;
SET @completedFeedback  = 1;

-- Product description
SET @OmoDescription = 'Nước Giặt Omo Matic với công nghệ Màn chắn Kháng bẩn Polyshield Xanh, giúp bao bọc và phủ một lớp màn chắn vô hình lên bề mặt sợi vải, loại bỏ nhanh chóng vết bẩn cứng đầu và mùi hôi trên áo quần.
\nBền Màu sau 100 lần giặt
\nChuyên dụng cho máy giặt cửa trước
\n11 Hãng máy giặt hàng đầu tin dùng như AQUA, LG, Panasonic
\nThân thiện môi trường với hoạt chất phân huỷ sinh học
\nOMO tự hào cùng các bé lấm bẩn trồng cây, kiến tạo thêm nhiều màn chắn xanh cho Việt Nam';

SET @NuocGiatArielDescription = 'Mua ARIEL CHÍNH HÃNG – GIÁ TỐT – CHẤT LƯỢNG CAO. ARIEL là thương hiệu giặt/xả biểu tượng cho sự sáng tạo cải tiến sản phẩm của tập đoàn P&G- là đơn vị nhãn hiệu giặt số 1 của châu Âu. Thương hiệu tiên phong trong việc ứng dụng công nghệ sinh học, ARIEL làm cho công việc giặt giũ nhẹ nhàng hơn.
\nNước Giặt ARIEL Cửa Trước Tươi Mát Rực Rỡ/ Bung Tỏa Đam Mê – Túi
\n\nĐẶC ĐIỂM NỔI BẬT :
\nNước giặt ARIEL Cửa Trước Lựa chọn số 1 bởi Electrolux cho máy giặt cửa trước. Công thức ít bọt dành cho máy giặt cửa trước ARIEL MATIC Cửa trước được thiết kế với công thức ít bọt được khuyên dùng bởi các nhà sản xuất máy giặt hàng đầu như Electrolux, Samsung, Toshiba.
Công thức làm sạch ARIEL 3D đánh bay vết bẩn Nước giặt ARIEL MATIC cửa trước không cần chất tẩy nhưng vẫn đảm bảo làm sạch vải do có công thức 3D thấm sâu vào từng sợi vải và bẻ nhỏ mọi vết bẩn, thay vì tẩy trắng vết bẩn như công thức của các sản phẩm giặt thông thường.';

SET @NuocGiatLixDescription = 'Túi nước giặt Lix siêu sạch hương hoa anh đào 2.4kg - Tẩy sạch cực mạnh vết bẩn
\n+ Dễ dàng loại bỏ các vết bẩn cứng đầu:
\nNước giặt Lix hương hoa dịu mát đậm đặc hơn, sẽ thấm sâu vào từng thớ vải, vừa giặt sạch dễ dàng hơn, vừa lưu lại mùi hương thơm mát gấp 2 lần so với bột giặt, cho quần áo của bạn thật sạch và tỏa hương thơm ngát.
Nước giặt Lix với công nghệ đột phá từ các hoạt chất loại bỏ vết bẩn, giúp không cần ngâm hay vò lâu. giúp quần áo sạch nhẹ nhàng, loại bỏ mùi mồ hôi, khói bụi và lưu lại hương thơm cỏ hoa thơm mát, dễ chịu. Với công nghệ mới có khả năng loại bỏ mọi vết bẩn cứng đầu như: vết cà phê, vết bẩn dầu mỡ…
\n+ Thiết kế bao bì bắt mắt, tiện lợi:
\nNước giặt Lix hương hoa dịu mát được thiết kế dạng túi gọn nhẹ, tiện lợi khi sử dụng cũng như dễ dàng bảo quản với nắp vặn nhỏ trên túi chắc chắn khi không dùng đến.
';

SET @NuocGiatLavenderDescription = 'Công dụng: - Diệt 99% vi khuẩn* - Loại bỏ 99.9% mạt bụi - Loại bỏ mùi khó chịu, để lại hương thơm tươi mới - Phù hợp với phơi trong nhà *Dữ liệu lấy từ phòng thí nghiệm Whealth Lohmann Centralin Cách dùng: Cho quần áo và nước giặt vào máy giặt theo l...
\n\nCông dụng:
\n- Diệt 99% vi khuẩn*
\n- Loại bỏ 99.9% mạt bụi
\n- Loại bỏ mùi khó chịu, để lại hương thơm tươi mới
\n- Phù hợp với phơi trong nhà
\n\nCách dùng: Cho quần áo và nước giặt vào máy giặt theo liều lượng hướng dẫn. Đối với các vết bẩn cứng đầu, hãy xử lý sơ bộ bằng cách cho một ít nước giặt trực tiếp lên vết bẩn và chà vào vải
';

SET @NuocRuaChenEarthChoiceDescription = 'Nước Rửa Chén Đậm Đặc Earth Choice Hương Chanh  500ml với thành phần tự nhiên nên không làm hại da tay, công thức tối ưu hóa thành phần thực vật giúp rửa sạch hiệu quả vết dầu mỡ, khử mùi tanh giúp ly chén & dĩa sạch, sáng bóng, thơm hương chanh tươi mát. Dịu nhẹ với da tay, không làm khô móng tay.
Tính năng vượt trội so với các loại nước rửa chén khác về hiệu quả tẩy sạch các vết bẩn dầu mỡ trên ly, chén, đĩa, xoong nồi…một cách nhanh chóng, một sản phẩm chắc chắn gia định bạn không thể bỏ qua.
\n\nHDSD: Sử dụng để rửa ly, chén và dĩa, và các vật dụng nấu nướng nhiều dầu và vết bẩn. Thấm miếng rửa chén với nước cho ướt đều các mặt sau đó đổ một lượng nước rửa chén vừa đủ lên miếng rửa chén, rửa từ đồ vật ít dơ rồi tới dơ nhiều sẽ giúp tiết kiệm nước rửa chén hiệu quả nhất.
\nHDBQ: đóng nắp sau khi dùng, tránh nơi có ánh sáng trực tiếp, tránh nơi quá ẩm ướt.';

SET @NuocRuaChenGiftDescription = 'Nước rửa chén Gift đánh bay mọi vết dầu mỡ cho chén bát sạch bóng, sạch nhanh chỉ với vài giọt. Nước rửa chén còn không làm hại da tay và không lo kích ứng da. Nước rửa chén Gift hương trà chanh chai 800g hương trà xanh dịu nhẹ, khử mùi cho chén bát của bạn.
\n\nƯu điểm của sản phẩm:
\nNước rửa chén Gift hương trà chanh được sản xuất từ nguyên liệu tự nhiên, không chứa chất độc hại, giúp khử sạch vết bẩn và mùi tanh khó chịu như thịt cá, dầu mỡ,... trên bát đĩa nhanh chóng. Ngoài ra, sản phẩm còn mang hương trà chanh tươi mát và dịu nhẹ trên chén đĩa, tạm biệt những mùi hôi khó chịu. Đặc biệt, nước rửa chén còn rất an toàn, không gây độc hại cho da tay của người dùng.';

SET @NuocPower100Description = 'Nước lau sàn nhà POWER100 giúp sàn nhà sạch bong sáng bóng, kháng khuẩn và đuổi côn trùng cực kỳ hiệu quả. Nước lau sàn nhà POWER100 hương hoa thiên nhiên can 3.8kg hương hoa thiên nhiên thơm ngát. Nước lau sàn mang đến cho bạn cảm giác thư giãn cho mọi không gian trong nhà.
\n\nNước lau sàn Power 100 được phát triển bởi công nghệ đột phá với sức mạnh làm sạch vượt trội, hoạt tính tẩy rửa năng động, xóa sạch mọi vết bẩn và bụi bám lâu ngày, cho sàn nhà sạch bóng không tì vết, khô nhanh tức thì, làm sáng bừng mọi ngóc ngách trong ngôi nhà chỉ với một lần lau.
\n\nNước lau sàn có mùi hương hoa thiên nhiên dịu nhẹ cho không gian trong nhà thêm tươi mát, hương thơm giúp đuổi bay côn trùng hiệu quả. Đồng thời, với công thức tiên tiến có khả năng kháng khuẩn tối ưu, khử mùi hôi khó chịu.
\nTham khảo: Cách chọn nước lau sàn chống muỗi.
\n\nNhằm giúp bạn tiết kiệm tiền bạc và công sức trong việc mua sắm nước lau sàn, POWER100 đã cho ra mắt loại nước lau sàn 3,8kg. Chất lượng vẫn như cũ, đảm bảo uy tín chất lượng nhưng giá thành lại rẻ hơn so với việc bạn mua loại túi nhỏ.';

SET @NuocSelectLilyDescription = '- Sản phẩm cải tiến hương lily và hoa hồng theo tone hương mới, tăng lượng hương giúp sản phẩm thơm hơn.
\n- Được tăng độ đậm đặc giúp tiết liệm hơn khi sử dụng, giảm nhờn – nhanh khô giúp không bị trơn trợt khi lau dọn nhà.
\n- Màu sắc sản phẩm: giảm độ Màu để nhìn tự nhiên hơn.
\n- Thiết kế nhãn theo đúng Màu của sản phẩm.
\n- Bổ sung thêm size túi giúp người tiêu dùng tiết kiệm hơn khi mua chai, thích hợp cho mọi gia đình.
\n- Sản xuất bởi: Công ty Cổ phần Bột giặt LIX là đơn vị nổi tiếng trên thị trường về hóa chất tẩy rửa với nhiều sản phẩm mang thương hiệu LIX được ưa chuộng trên thị trường.';

SET @NuocTayDuckDescription = 'Với công thức tẩy rửa nhà tắm siêu ưu việt, nước tẩy bồn cầu Duck giúp tiêu diệt 99,9% vi khuẩn từ sâu bên trong mép bồn cầu, loại bỏ cặn bẩn, mùi hôi hiệu quả. Nước tẩy bồn cầu & nhà tắm Duck Mr Muscle 700ml tẩy sạch vi khuẩn mà không có hại cho da tay.
\n\nĐôi nét về thương hiệu: Duck là thương hiệu chuyên sản xuất và cung cấp các mặt hàng tẩy rửa bề mặt đồ dùng trong nhà tắm nổi tiếng vậ hiện đang thuộc quản lý của Công ty Tập đoàn S. C.Johnson & Son. Hiện nay, Duck đã trở thành cái tên nổi bật qua nhiều thế hệ người tiêu dùng Việt Nam, mang đến đa dạng sản phẩm đat chuẩn chất lượng, với quy trình kiểm định hiện đại, an toàn cho khách hàng.
\n\nƯu điểm của sản phẩm:
\n- Với công thức tẩy rửa cực mạnh, Duck Mr. Muscle 700ml có tác dụng khử mùi, giúp tẩy sạch vết gỉ sét, vết hóa vôi, vết xà phòng đọng lại, vết thâm đen trong kẽ gạch, vết cáu bẩn trên bồn cầu...
\n- Sản phẩm còn diệt trùng hiệu quả đến 99.9% ngay khi tiếp xúc trên bề mặt, cho bồn cầu sạch bóng và trắng sáng, mang lại hương thơm tự nhiên cho không gian.
\n- Có thiết kế dạng chai tiện lợi, dễ sử dụng, giúp phân tán chất lỏng đến tất cả mọi bề mặt, mọi vị trí mong muốn, cho hiệu quả vệ sinh cao hơn.';

SET @NuocTaySWATDescription = 'Nước tẩy nhà tắm Swat loại bỏ nhanh vết bẩn, vết ố vàng, mảng bám, mùi hôi khó chịu. Nước tẩy nhà tắm giúp giữ cho nhà tắm luôn sạch bóng như mới, đảm bảo vệ sinh an toàn cho gia đình bạn. Nước tẩy nhà tắm Swat siêu sạch 1 lít sạch nhanh vết bẩn, sạch cả vi khuẩn.
\n\nĐôi nét về thương hiệu: Thương hiệu Swat hiện thuộc công ty TNHH Sản xuất – Thương mại CLEAN HOUSE và hiện đang là một trong những nhà sản xuất các mặt hàng hóa phẩm chuyên tẩy rửa và vệ sinh nhà cửa, hàng gia dụng nổi tiếng hiện nay. Với danh hiệu top 50 thương hiệu - nhãn hiệu nổi tiếng trong ngành hàng hóa phẩm, Swat đã tạo được ấn tượng trong lòng phần đông người tiêu dùng Việt, thở thành người bạn đồng hành trong công việc vệ sinh nhà cửa mỗi ngày.
\n\nCông dụng: Diệt nhanh, diệt gọn, diệt sạch các vết bẩn, vết ố vàng, vết rỉ sét, vết vôi hóa, vết xà phòng...đọng lại trong nhà tắm như mặt sàn, bồn tắm, bồn rửa mặt. Đảm bảo vệ sinh và an toàn cho gia đình bạn
\n\nLưu ý: Để xa tầm tay trẻ em. Mang găng tay và giày bảo hộ (ủng) khi chà rửa. Không trộn chung với bất kỳ sản phẩm hay hóa chất khác. Tránh tiếp xúc với quần áo, da, mắt. Nếu dính vào mắt rửa sạch ngay với nhiều nước và đến kiểm tra tại cơ sở y tê
';

SET @ChaGioTomCuaDescription = 'Chả giò tôm cua Vissan được sản xuất theo quy trình khép kín với những nguyên liệu tự nhiên, được chọn lựa kỹ lưỡng từ khâu chọn lựa đến khâu chế biến đảm bảo chất lượng người tiêu dùng. Với chả giò tôm cua người dùng sẽ cảm nhận được vị thịt tôm và cua tự nhiên, hương vị của các loại gia vị hòa quyện, giòn rụm của bánh đa khó quên.
\nSản phẩm được đóng gói an toàn, cuốn sẵn tiện dụng chỉ việc cho vào rán kèm nước chấm pha sẵn thơm ngon đặc trưng, tiện dụng cho bữa cơm của gia đình bạn.
\n\nThành phần: Bánh tráng (gạo, nước, bột năng, muối), tôm (20%), cua (10%), nạc heo, mỡ heo, tôm, củ sắn, khoai môn, hành, tỏi, nấm mèo, bún tàu, đường, muối i-ốt, tiêu, chất điều vị (621).';

SET @GioHeoXongKhoi = 'Được chế biến từ thành phần thịt heo rút xương tươi ngon, đảm bảo an toàn vệ sinh thức phẩm. Sản phẩm không chứa hóa chất bảo quản, chất phụ gia ảnh hưởng đến sức khỏe người tiêu dùng. Với những bà nội trợ luôn bận rộn, không có nhiều thời gian để nấu nướng thì sản phẩm chính là sự lựa chọn thích hợp.
\n\nThành phần: Giò heo rút xương (85%), nước, muối i-ốt (muối, kali iodat), đường, chất điều vị (621), chất giữ ẩm (451i, 452i), hương khói tự nhiên, chất điều chỉnh độ acid (262i), chất chống oxy hóa (316).';

SET @KemWallOreo = 'Kem Wall’s Tub Oreo Cookies được sản xuất trên dây chuyền công nghệ hiện đại, sử dụng nguyên liệu tự nhiên, hoàn toàn không chứa các thành phần hóa học, chất phụ gia. Sản phẩm là sự kết hợp hoàn hảo của sữa hòa quyện với mùi hương thơm mát của vani, đường, bơ béo hay những mảnh vụn của bánh Oreo… mang lại cho bạn sự thích thú, mới lạ ngay khi thưởng thức.
\nHương sôcôla tuyệt hảo với cảm giác mát lạnh, phù hợp để thưởng thức trong những ngày hè nóng bức hay những lúc mệt mỏi, stress trong cuộc sống hàng ngày.
\n\nThành phần: Nước, đường, siro gluco, vụn sôcôla, đạm Whey cô đặc, dầu dừa, bột cacao, bột sữa gầy, bột tách kem, hương vani tổng hợp, hương đắng tổng hợp, hương kem tổng hợp.
';

SET @BotMilo = 'Sữa lúa mạch Nestlé Milo Nguyên chất với chiết xuất Protomalt® từ mầm lúa mạch kết hợp với vitamin cùng khoáng chất thiết yếu giúp bé yêu phát triển thể chất toàn diện và đảm bảo năng lượng cho cả ngày dài năng động. Thức uống với hương vị thơm ngon, nguyên chất, là sự lựa chọn tuyệt vời của mẹ cho sự phát triển của bé.
\n\nThành phần: Protomalt® 32 % (chiết xuất từ mầm lúa mạch – extract from malted barley, tinh bột sắn), đường, sữa bột tách kem (skimmed milk powder), bột cacao, dầu thực vật, bột whey, các khoáng chất (dicalci phosphat, dinatri phosphat, sắt pyrophosphat), dầu bơ (từ sữa – from milk), sirô glucose, các vitamin (vitamin C, niacin, vitamin B6, B2, D, B12), muối i-ốt và hương vani tổng hợp.
';

SET @NhoMauDon = 'Nho mẫu đơn là giống nho mọng nước, quả có hình tròn đều, vị ngọt đậm đà và hương thơm nhẹ. Nho mẫu đơn tại Bách hóa XANH được đảm bảo nguồn gốc xuất xứ từ Trung Quốc và được đóng gói trong hộp nhựa sạch sẽ, đảm bảo vệ sinh.
\n\nGiá trị dinh dưỡng: Nho mẫu đơn chứa nhiều vitamin C, K, B6 và các khoáng chất như magne, sắt, kali. Đặc biệt, hàm lượng sắt dồi dào trong nho mẫu đơn rất tốt cho phụ nữ, trẻ em và những người bị thiếu máu. Bên cạnh đó, nho mẫu đơn cũng chứa nhiều chất chống oxy hóa, như nhóm thực vật polyphenol có lợi cho sức khỏe tim mạch và ngăn ngừa bệnh ung thư.
';

SET @SuaChuaVinamilk = 'Sữa chua của thương hiệu sữa chua Vinamilk chứa nhiều canxi, vitamin, khoáng chất ở dạng dễ hấp thu, kích thích vị giác, tăng cường sức khỏe hệ tiêu hóa. 2 lốc sữa chua Vinamilk nha đam hộp 100g là sự kết hợp giữa sữa chua sánh mịn với vị nha đam thơm ngon.
\n\nThành phần: Sữa, đường, nha đam, gelatin thực phẩm, chất ổn định, men Streptococcus thermophilus và Lactobacillus bulgaricus.
';

SET @SuaTuoiVinamilk = 'Sữa tươi tiệt trùng VNM có đường hộp 180ml được làm từ 100% sữa bò tươi nguyên chất giàu các dưỡng chất tự nhiên, tươi ngon & bổ dưỡng. Bổ sung Vitamin D3 theo chuẩn EFSA Châu Âu giúp hỗ trợ miễn dịch, cho cả gia đình thêm khỏe mạnh để luôn sẵn sàng làm tốt những công việc quan trọng mỗi ngày.
\n\nThành phần: chứa đạm, chất béo, canxi và các vitamin.
';

SET @SuaTamLifeBoy = 'Thiết kế cần gạt cho bạn lấy sữa tắm dễ dàng hơn.
\nCông thức ion bạc và bạc hà giúp bảo vệ khỏi vi khuẩn hơn gấp 10 lần
\nChứa các tinh thể bạc hà chiết xuất từ la bạc hà tươi, giúp làm sạch sâu các lỗ chân lông
';

SET @NemLui = 'Nem Lụi do Công ty VISSAN sản xuất và phân phối đảm bảo chất lượng tuyệt hảo, thơm ngon chuẩn vị miền trung với hương vị đặc trưng riêng mà không nơi nào có được. Sản phẩm thường được dùng kèm với bánh tráng, rau sống và nước chấm.
\n\nThành phần: Nạc heo, mỡ heo, đường, nước mắm, muối i-ốt (muối, kali iodat), tỏi, chất điều vị (621).
';

SET @TaoPinkLady = 'Táo nhập khẩu 100% từ New Zealand. Đạt tiêu chuẩn xuất khẩu toàn cầu. Bảo quản tươi ngon đến tận tay khách hàng. Trái vừa ăn, chắc tay, vỏ táo màu hồng xanh đẹp mắt.
';

SET @MiLauTomOmachi = 'Mì khoai tây lẩu tôm chua cay Omachi được đóng gói tiện dụng cho bạn sử dụng cũng như bảo quản. Vỏ đựng sản phẩm làm từ nguyên liệu sạch, không lẫn tạp chất hóa học độc hại. Sản phẩm do Csfood phân phối luôn mang đến chất lượng tốt nhất cho người tiêu dùng.
\n\nThành phần: Đường, muối, dầu thực vật, chất điều vị, gia vị (tỏi, ớt, tiêu, ngò thơm),...
';

SET @StrongbowAppleGold = 'STRONGBOW Vị Gold Apple là loại đồ uống có nguồn gốc châu Âu và được nhiều người trên thế giới ưa chuộng. Sản phẩm được chế biến bằng cách lên men hoa quả tự nhiên, tạo nên chất men thuần khiết và hương vị hài hòa.
\nSTRONGBOW Vị Gold Apple thích hợp tại các bữa tiệc tại gia, tiệc nướng, lẩu, liên hoa cuối tuần, họp mặt bạn bè... Sản phẩm chế biến dạng lon, tiện dụng việc sử dụng, bảo quản và di chuyển.
\n\nThành phần: Nước, nước táo lên men với sucrose (cider), si-rô, chất tạo khí carbonic (E290), chất điều chỉnh độ acid (E296), hương táo tự nhiên, màu caramel (E150a), chất bảo quản Kali Metabisulfit (E224).
';

SET @HaCaoMiniCauTre = 'Há cảo thực phẩm thơm ngon khó cưỡng, kết hợp với nhiều món ăn ngon, điển hình là há cảo Cầu Tre. Há cảo mini nhân thịt Cầu Tre 500g được chế biến từ các nguyên liệu chất lượng cao, gia vị đậm đà, kích thước mini gọn gàng và tiện lợi, dễ ăn.
\n\nThành phần: Da bột bánh, thịt heo, củ sắn, cá tra, tôm, bột, tinh bột bắp, đạm đậu nành, đuòng cát, cà rốt, bột hương thịt, chất điều vị,...
';

SET @BongTrangDiemSilcot = 'Bông trang điểm Silcot là sản phẩm chăm sóc da cao cấp bán chạy số 1 Nhật Bản trong hơn 10 năm liền. Được làm từ 100% sợi bông tự nhiên, bông trang điểm mềm xốp, êm ái và vô cùng dịu nhẹ với da. Sợi bông thấm được dàn đều cùng thiết kế dạng túi giúp miếng bông trang điểm không bị xù, biến dạng hoặc để lại xơ bông trên mặt đồng thời tiết kiệm dung dịch dưỡng da và tăng cường đối da hiệu quả trên da.
';

SET @XaLachLolo = 'Xà lách lolo xanh thủy canh chứa hàm lượng lớn các khoáng chất canxi, sắt, magie, phốt pho, natri, kẽm, và đặc biệt hàm lượng kali và canxi cao hơn so với các loại xà lách là màu xanh. Hàm lượng vitamin A cao hơn so với 1 số loại rau cải ăn lá, và chứa một số vitamin cần thiết khác như vitamin C, B6, folate, E, thiamin, riboflavin, niacin.
\n\nXà lách lolo xanh thủy canh có thể sử dụng để làm nhiều món ăn nhưng thích hợp nhất là món salad, các món cuộn, hay ăn kèm các loại nước sốt, canh chua,.. Hương vị của rau sẽ ngon hơn khi dùng với dầu olive, muối, giấm hoặc sốt mayonaise. Người dùng có thể thêm các nguyên liệu như củ đậu, cà chua, đậu phộng, phomai sợi,… để tăng hương vị món ăn.
';

SET @CaiThao = 'Bắp cải thảo là loại rau có bẹ lá to, giòn, ngọt thường được dùng để nấu canh, xào chung với rau củ hoặc để muối kim chi.
\n\nCải thảo cũng giống với các loại rau khác, có thể sử dụng phổ biến trong bữa ăn hàng ngày, có thể kể đến một số món ăn chế biến từ cải thảo như: canh cải thảo, cải thảo cuốn thịt, cải thảo xào,... Ngoài ra, khi nhắc đến cải thảo thì bạn sẽ nhớ ngay đến món ăn đặc sản của Hàn Quốc đó chính là kim chi, cay cay, chua chua kích thích vị giác vô cùng.
';

SET @NuocXaComfort = 'Những bộ cánh yêu thích nhanh chóng bạc màu, sờn vải sau mỗi lần giặt khiến bạn đau đầu tìm giải pháp? Đừng lo, vì đã có chuyên gia chăm sóc áo quần Comfort! Nước Xả Vải Comfort Chăm Sóc Chuyên Sâu mới sẽ giúp bạn ngăn bạc màu và ngừa sờn vải. Với công thức Ultra Care độc quyền, nước xả vải Comfort thẩm thấu sâu vào từng sợi vải tạo nên lớp màng giúp bảo vệ màu sắc và độ bền sợi vải, cũng như lưu lại hương thơm lôi cuốn bền lâu, giữ áo quần luôn như mới sau nhiều lần giặt.
';

SET @PhoMaiVienHoaDanh = 'Phô Mai Que Hoa Doanh Phô mai que với lớp vỏ vàng giòn rụm và phần phô mai béo ngậy hương thơm tự nhiên hấp dẫn.
\n\nPhô mai que đã trở thành món ăn thông dụng, được dùng như món tráng miệng trong các nhà hàng, các quán trà sữa hay những quán ăn vặt...Sản phẩm phù hợp với mọi lứa tuổi từ trẻ em đến người lớn do hương thơm tự nhiên, cực kỳ lôi cuốn.
';

SET @sapVaseline = 'Sáp Vaseline sẽ giúp bảo vệ da khỏi những tác động của thời tiết và nó hoạt động như chất hàn gắn cho các tế bào của da và ngăn cản sự mất nước của làn da.Giúp cho các tế bào da sẽ tự củng cố và tái tạo từ bên trong,chống khô da ,trị nứt nẻ ,giúp hàn gắn lại những vết cắt nhỏ và những vết bỏng.
'
;

SET @BiaHeineken = 'Heineken là loại bia có hương vị đậm đà, khó quên và luôn bỏ xa các đối thủ cạnh tranh trong các cuộc thử nghiệm về chất lượng giữa các lọai bia. Trong số những người tham gia blind testing trong năm 2003, 90% cho biết họ sẽ chọn lại Bia Heineken (Hà Lan).
\nHeineken được tạo ra bởi một nhóm người tận tâm theo đuổi chất lượng cao nhất, bảo tồn theo công thức phát minh ra ba thế hệ trước bởi gia đình Heineken. Hương vị của nó hơi chua chua, ngọt, hương thơm nhẹ, màu sắc tươi sáng và rõ nét, đặc biệt được làm từ nước tinh khiết, hoa bia và mạch nha lúa mạch, Heineken không chứa các chất phụ gia.
';

SET @TraTamSenDaiGiaDescription = 'Trà tâm sen (tim sen) là sử dụng phôi mầm nằm giữa hạt sen làm trà. Tâm sen có tác dụng thanh lọc cơ thể qua 2 đường tiết niệu và gan, lại thêm tác dụng an thần giúp ngủ rất sâu và êm.
\n\nTâm Sen có chất lượng tốt nhất phải được lấy từ hạt sen đã chín. Thu hoạch khi sen vừa chín tới, hạt sen đang dần trở nên sẫm màu và bóc vỏ hạt ngay trước khi nó trở nên cứng như một lớp sừng.
\n\nTrà tâm sen trên thị trường sẽ có chất lượng khác nhau chủ yếu là do thời điểm thu hoạch. Một số nơi lấy tâm sen khi vẫn còn xanh để dễ bóc hạt để đạt năng suất cao hơn, tất nhiên điều đó sẽ ảnh hưởng đến chất lượng.';

SET @TraCungDinhHueDescription = 'Trà cung đình Huế G8 được bào chế từ 16 vị thảo dược mỗi vị thảo dược có một công dụng riêng khi kết hợp với nhau tạo ra một sản phẩm rất tốt cho sức khoẻ. Các vị thảo dược được thu mua từ ba miền Bắc Trung Nam hoàn toàn xanh sạch và là thức uống có lợi cho sức khỏe. Vậy hãy uống trà Cung đình Huế để cảm nhận được hương sắc vị thần và giúp cho long thể khoẻ mạnh mỗi ngày!
\n\nThưởng thức trà Huế G8 vừa khiến tinh thần thư giãn vừa các tác dụng thanh nhiệt, giải độc và mát gan. Vua chúa, Hoàng Tộc hay bậc quan đại thần thời xưa có lối sống toàn là “Sơn trân hải vị”. Trong đó, thưởng Trà Cung Đình là một thú vui tao nhã của Vua chúa xưa được lưu truyền cho tới ngày nay.
\n\nĐược chế biến từ 16 loại thảo dược thiên nhiên tốt cho sức khoẻ như: Atiso, cúc hoa, cỏ ngọt, hoài sơn, đẳng sâm, đại táo, hồng táo, hồi hoa, cam thảo bắc, hoa lài, hoa hòe, thảo quyết minh, khổ qua, kỷ tử, vối nụ, tim sen và một số thảo dược gia truyền quý. Trà cung đình G8 có vị ngọt nhẹ nhàng, thanh tao.';

SET @NuocEpTaoMarigoldDescription = '- Xuất xứ: Malaysia
\n- Thông tin sản phẩm:
\n- Nước Ép MariGold là nước trái cây ép được sản xuất trên dây chuyền công nghệ hiện đại, không đường, không sử dụng chất bảo quản hay màu nhân tạo.
\n- Nước Ép được kết hợp giữa nhiều loại trái cây như táo, cam, cà rốt theo tỉ lệ pha trộn hài hòa đã đem đễ cho sản phẩm hương vị thơm ngon hảo hạng.
\n- Sử dụng Nước Ép thường xuyên sẽ giúp cho cơ thể bạn khỏe khoắn và tinh thần luôn tươi vui mỗi ngày.
\n- Nước Ép được đóng chai với nắp nhựa xoáy tiện dụng và giúp bảo quản nước ép luôn giữ được hương vị tự nhiên thơm ngon lâu dài, đem lại sự yên tâm cho bạn và cả gia đình mỗi khi sử dụng.';

SET @NuocEpLuuTaoVfreshDescription = 'Sản phẩm nước ép trái cây từ thương hiệu nước ép Vfresh được làm từ nguyên liệu tự nhiên tươi ngon có hương vị ngọt dịu, thơm mát từ những trái táo tươi ngon, sản phẩm chứa nhiều khoáng chất, dinh dưỡng, chất chống oxy hóa, lượng vitamin C cao tốt cho sức khỏe
\n\nNước ép lựu táo Vfresh được làm từ 100% lựu táo tự nhiên có hương vị ngọt dịu, thơm mát từ những trái táo tươi ngon, sản phẩm chứa nhiều khoáng chất, dinh dưỡng, chất chống oxy hóa, lượng vitamin C cao tốt cho hệ miễn dịch và cơ thể, giúp phòng ngừa ung thư một cách hiệu quả.
\n\nNước ép táo có rất nhiều lợi ích. Táo là loại trái cây tốt nhất cho sức khỏe và tiêu thụ nó dưới dạng nước ép thậm chí còn tốt hơn. Nước ép táo có thể giải độc và làm sạch cơ thể. Ngoài ra nước táo Vfresh còn có tác dụng hỗ trợ điều trị bệnh thiếu máu, giảm viêm khớp và yếu cơ.
\n\nSản phẩm được sản xuất từ trái cây nguyên chất, không phẩm màu, không chứa chất bảo quản, đạt tiêu chuẩn an toàn vệ sinh thực phẩm, an toàn tuyệt đối cho người tiêu dùng.';

SET @MiHaoHaoKimChi = 'Hương vị mới Lẩu Kim Chi Hàn Quốc còn sở hữu vị nước súp ngon chua chua cay cay thơm lừng mùi kim chi, đặc biệt phù hợp với khẩu vị của người Việt Nam. Cùng với tính tiện lợi sẵn có, Hảo Hảo tin chắc rằng bạn có thể thưởng thức hương vị mới này ở bất kì khi nào và bạn sẽ có thêm thật nhiều hạnh phúc khi nhớ đến những ký ức tốt đẹp và động lực để phát triến trong tương lai.
\n\nThành phần: Bột mì, dầu cọ, tinh bột khoai mì, muối, đường, nước mắm, chất điều vị (621), chất ổn định (451(i), 501(i)), chất điều chỉnh độ acid (500(i)), phẩm màu curcumin tự nhiên, bột nghệ, chất chống oxy hóa (320, 321). Muối, dầu cọ, chất điều vị (621, 631, 627, 951), đường, các gia vị (tỏi, ớt, gừng, tiêu), chất điều chỉnh độ acid (330, 296), hương liệu (hương kim chi tự nhiên, hương bò tổng hợp), chiết xuất nấm men, chất chống đông vón (551), hành lá sấy, phẩm màu paprika oleoresin tự nhiên.
';

SET @SuaTamXmenDetox = 'Sữa tắm Detox dành cho nam giới đầu tiên tại Việt Nam với Than tre hoạt tính giúp loại bỏ 5 tác nhân ô nhiễm, làm sạch sâu, loại bỏ hiệu quả dầu nhờn và bụi bẩn trên cơ thể.
\n\nThành phần: Water, Sodium Laureth Sulfate, Cocamidopropyl Betaine, Perfume, Cocamide MEA, Sodium Chloride, Potassium Cocoyl Glycinate, Sodium Lauroyl Sarcosinate, Menthol, Hydroxyethylcellulose, Mentha Arvensis Leaf Oil, Mentha Piperita (Peppermint) Oil, Citric Acid, Tetrasodium EDTA, Benzophenone-4, BHT, Sodium Cumenesulfonate, Styrene/ Acrylates Copolymer, Methylchloroisothiazolinone, Methylisothiazolinone, CI 60730, CI 42051.
';

SET @KemYukimiMatcha = 'Đậm đà hương vị Nhật Bản với kem Mochi Yukimi Daifuku của Lotte.
\nMochi Lotte là bánh mochi nhân kem matcha ăn vị khá lạ và đặc trưng hương vị Nhật Bản, ngọt vừa, vị beo béo vỏ mềm dẻo, mịn thơm.
\n\nThành phần: Đường, siro bắp, bột gạo, dairy product (bột sữa tách béo 10%, bơ), dầu thực vật, siro bắp fructose, tinh bột bắp, bột lòng trắng trứng, chất ổn định (dextrin), muối, chất nhũ hóa (este của acid béo với propylene glycol; este của polyglycerol với acid béo), chất ổn định (gôm gua; gôm đậu carob/gôm đậu locust; carrageenan), tinh bột biến tính (oxidized starch), hương tổng hợp (hương matcha, hương sữa), màu thực phẩm tự nhiên (chất chiết xuất từ annatto, norbixin-based; chất chiết xuất từ gardenia yellow).
';

SET @NemBoTieuXanh = 'Sản phẩm Nem Bò tiêu xanh được chế biến từ nguồn nguyên liệu thịt nạc bò tươi, sạch đạt chuẩn ESCAS và được giết mổ trực tiếp tại nhà máy của Công ty. Do đó, thịt khi đưa vào sản xuất vẫn đảm bảo được độ kết dính và dai giòn cho món ăn. Với hương vị thơm ngon từ thịt bò tươi nguyên chất cùng những thớ thịt dai giòn sực sực kết hợp độc đáo cùng tiêu xanh thơm lừng và vị nồng nàn của xả làm cho món Nem bò tiêu xanh trở nên vô cùng hấp dẫn.
\nThêm vào đó là tính tiện dụng của sản phẩm sẽ giúp người dùng dễ dàng chế biến và tiết kiệm thời gian khi nấu nướng. Chỉ cần 10 - 15 phút chiên hoặc nướng sản phẩm bằng nồi chiên không dầu hoặc chảo là có ngay những chiếc nem bò tiêu xanh thơm ngon lạ vị để thưởng thức cùng bạn bè và gia đình.
';


-- Configuration
INSERT INTO `saving_hour_market`.`configuration` (`id`, `limit_of_orders`, `extra_shipping_fee_per_kilometer`, `initial_shipping_fee`, `min_km_distance_for_extra_shipping_fee`, `delete_unpaid_order_time`, `time_allowed_for_order_cancellation`, `limit_meter_per_minute`, `allowable_order_date_threshold`,`system_status`)
--     VALUES (`id`, `limit_of_orders`, `number_of_suggested_pickup_point`, `delete_unpaid_order_time`, `system_status`);
    VALUES  (UUID_TO_BIN('accf78c1-5541-11ee-8a50-a85e45c41921'), 100, 1000, 10000, 2, 1, 0, 5, 2, @systemActive);


-- Customer
INSERT INTO `saving_hour_market`.`customer` (`id`, `status`, `date_of_birth`, `address`, `avatar_url`, `email`, `full_name`, `phone`, `gender`)
--     VALUES  ('id', 'status', '# date_of_birth', 'address', 'avatar_url', 'email', 'full_name', 'password', 'phone', 'username'),
    VALUES  (UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', 'luugiavinh0@gmail.com', 'Luu Gia Vinh', '0902828618', @male),
            (UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '50 Lê Văn Việt, Hiệp Phú, Quận 9, Thành phố Hồ Chí Minh', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', 'ladieuvan457@gmail.com', 'La Dieu Van', '0961780569', @female),
            (UUID_TO_BIN('accef619-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '81 Nguyễn Xiển, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', 'chuonghoaiviet555@gmail.com', 'Chuong Hoai Viet', '0904757264', @male),
            (UUID_TO_BIN('accef73d-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '740 Nguyễn Xiển, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', 'donganthu977@gmail.com', 'Dong An Thu', '0903829475', @female),
            (UUID_TO_BIN('accef866-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '269 Đ. Liên Phường, Phước Long B, Quận 9, Thành phố Hồ Chí Minh', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', 'ngachongquang185@gmail.com', 'Ngac Hong Quang', '0904659243', @male),
            (UUID_TO_BIN('accef988-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '441 Lê Văn Việt, Tăng Nhơn Phú A, Quận 9, Thành phố Hồ Chí Minh', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', 'ungthanhgiang458@gmail.com', 'Ung Thanh Giang', '0905628465', @female);


-- Product Consolidation Area
INSERT INTO `saving_hour_market`.`product_consolidation_area` (`id`, `address`, `latitude`, `longitude`, `status`)
VALUES  (UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), 'Đường N7, Tăng Nhơn Phú A, Thủ Đức, Hồ Chí Minh', 10.846756594531838, 106.80459035612381, @enable),
        (UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921'), '9 Nam Hòa, Phước Long A, Thủ Đức, Hồ Chí Minh', 10.821593957000061, 106.76009552300007, @enable);
--             (UUID_TO_BIN('ec5dfb70-56dc-11ee-8a50-a85e45c41921'), ),
--             (UUID_TO_BIN('ec5dfc7e-56dc-11ee-8a50-a85e45c41921'), );


-- Pickup point
INSERT INTO `saving_hour_market`.`pickup_point` (`id`, `address`, `latitude`, `longitude`, `status`)
--     VALUES ('id', 'address', 'latitude', 'longitude', 'status');
    VALUES  (UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', 10.845020092805793, 106.83102962168277, @enable),
        --       chua co trong supermarket address
        --         (UUID_TO_BIN('accf0be1-5541-11ee-8a50-a85e45c41921'), '20 Đ. Nguyễn Đăng Giai, Thảo Điền, Quận 2, Hồ Chí Minh', 10.8019121, 106.7362979, @enable),
        (UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh', 10.8059505, 106.7891284, @enable),
        (UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', 10.85273099400007, 106.75072682500007, @enable),
        --       chua co trong supermarket address
        --         (UUID_TO_BIN('accf0f40-5541-11ee-8a50-a85e45c41921'), '430 Huỳnh Tấn Phát, Bình Thuận, Quận 7, Hồ Chí Minh', 10.7457942, 106.7290568, @enable),
        (UUID_TO_BIN('accf105d-5541-11ee-8a50-a85e45c41921'), '77C Trần Ngọc Diện, Thảo Điền, Thủ Đức, Hồ Chí Minh', 10.80274197700004, 106.73845902300008, @enable);
--             (UUID_TO_BIN('accf117b-5541-11ee-8a50-a85e45c41921'), '96 Đường Số 4, Phước Bình, Thủ Đức, Hồ Chí Minh', 10.818471742000042, 106.77107158600006, @enable, UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921'));


-- Pickup_point_Product_Consolidation_Area
INSERT INTO `saving_hour_market`.`pickup_point_product_consolidation_area` (`pickup_point_id`, `product_consolidation_area_id`)
--      VALUES (`pickup_point_id`, `product_consolidation_area_id`)
    VALUES  (UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf105d-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921'));



-- Staff
INSERT INTO `saving_hour_market`.`staff` (`id`, `email`, `full_name`, `role`, `avatar_url`, `status`, `deliver_manager_id`)
--     VALUES (`id`, `email`, `full_name`, `role`, `avatar_url`, `status`);
    VALUES  (UUID_TO_BIN('accf4aa8-5541-11ee-8a50-a85e45c41921'), 'hieuntse161152@fpt.edu.vn', 'Trung Hieu', 'ADMIN', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, null),
            (UUID_TO_BIN('accf4c03-5541-11ee-8a50-a85e45c41921'), 'vinhlgse161135@fpt.edu.vn', 'Gia Vinh', 'STAFF_SLT', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, null),
            (UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), 'quangphse161539@fpt.edu.vn', 'Hong Quang', 'STAFF_ORD', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, null),
            (UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), 'nguoidonggoi1@fpt.com.vn', 'Le Van B', 'STAFF_ORD', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, null),
            (UUID_TO_BIN('accf4e43-5541-11ee-8a50-a85e45c41921'), 'tuhase161714@fpt.edu.vn', 'Ha Tu', 'STAFF_MKT', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, null),
            (UUID_TO_BIN('accf4f95-5541-11ee-8a50-a85e45c41921'), 'anhpnhse161740@fpt.edu.vn', 'Hung Anh', 'STAFF_DLV_1', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, null),
            (UUID_TO_BIN('16fdc186-8078-11ee-bef9-a85e45c41921'), 'nguoiquanli1@fpt.com.vn', 'Le Van A', 'STAFF_DLV_1', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, null),
            (UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'), 'nguoigiaohang1@fpt.com.vn', 'Nguyen Van A', 'STAFF_DLV_0', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, UUID_TO_BIN('accf4f95-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e0293-56dc-11ee-8a50-a85e45c41921'), 'nguoigiaohang2@fpt.com.vn', 'Nguyen Van B', 'STAFF_DLV_0', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, UUID_TO_BIN('accf4f95-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e0433-56dc-11ee-8a50-a85e45c41921'), 'nguoigiaohang3@fpt.com.vn', 'Nguyen Van C', 'STAFF_DLV_0', 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media', @enable, UUID_TO_BIN('accf4f95-5541-11ee-8a50-a85e45c41921'));



-- Staff_Pickup_Point
INSERT INTO `saving_hour_market`.`staff_pickup_point` (`staff_id`, `pickup_point_id`)
--    VALUES (`id`, `email`, `full_name`, `role`, `avatar_url`, `status`);
    VALUES  (UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'));




-- Product category
INSERT INTO `saving_hour_market`.`product_category` (`id`, `name`, `status`)
--     VALUES  ('id', 'name');
    VALUES  (UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921'), 'Đồ uống', @enable),
            (UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921'), 'Thực phẩm', @enable),
            (UUID_TO_BIN('accefcee-5541-11ee-8a50-a85e45c41921'), 'Gia vị', @enable),
            (UUID_TO_BIN('accefe0d-5541-11ee-8a50-a85e45c41921'), 'Chăm sóc cá nhân', @enable),
            (UUID_TO_BIN('acceff37-5541-11ee-8a50-a85e45c41921'), 'Thức ăn cho thú cưng', @enable),
            (UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921'), 'Vật tư vệ sinh', @enable);


-- Product sub category
INSERT INTO `saving_hour_market`.`product_sub_category` (`id`, `name`, `allowable_display_threshold`, `product_category_id`, `image_url`, `status`)
--     VALUES ('id', 'name', 'allowable_display_threshold', 'product_category_id');
    VALUES  (UUID_TO_BIN('accf3fdf-5541-11ee-8a50-a85e45c41921'), 'Trái cây', 3, UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ffruit.png?alt=media', @enable),
            (UUID_TO_BIN('ec5e1ddc-56dc-11ee-8a50-a85e45c41921'), 'Rau củ', 2, UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fvegetable.png?alt=media', @enable),
            (UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921'), 'Thực phẩm đông lạnh gói', 4, UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ffrozen-food.png?alt=media', @enable),
            (UUID_TO_BIN('accf4210-5541-11ee-8a50-a85e45c41921'), 'Đồ tráng miệng lạnh', 4, UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ffrozen-desert.png?alt=media', @enable),
            (UUID_TO_BIN('accf4875-5541-11ee-8a50-a85e45c41921'), 'Mì', 5, UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnoodles.png?alt=media', @enable),
            (UUID_TO_BIN('accf4766-5541-11ee-8a50-a85e45c41921'), 'Mỹ phẩm', 30, UUID_TO_BIN('accefe0d-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fcosmetics.png?alt=media', @enable),
            (UUID_TO_BIN('accf442f-5541-11ee-8a50-a85e45c41921'), 'Đồ dùng vệ sinh cá nhân', 30, UUID_TO_BIN('accefe0d-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ftoiletries.png?alt=media', @enable),
            (UUID_TO_BIN('accf4547-5541-11ee-8a50-a85e45c41921'), 'Nước giặt xã', 30, UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Flaundry-detergent.png?alt=media', @enable),
            (UUID_TO_BIN('ea6d53d6-89ad-11ee-bef9-a85e45c41921'), 'Nước rửa chén', 30, UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdish-detergent.png?alt=media', @enable),
            (UUID_TO_BIN('ea6d7645-89ad-11ee-bef9-a85e45c41921'), 'Nước lau sàn', 30, UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ffloor-cleaner.png?alt=media', @enable),
            (UUID_TO_BIN('ea6d814d-89ad-11ee-bef9-a85e45c41921'), 'Nước tẩy nhà vệ sinh', 30, UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ftoilet-detergent.png?alt=media', @enable),
            (UUID_TO_BIN('accf4320-5541-11ee-8a50-a85e45c41921'), 'Sữa', 2, UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdiary-product.png?alt=media', @enable),
            (UUID_TO_BIN('accf4656-5541-11ee-8a50-a85e45c41921'), 'Đồ uống có cồn', 5, UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Falcoholic-drink.png?alt=media', @enable),
            (UUID_TO_BIN('ea6fa014-89ad-11ee-bef9-a85e45c41921'), 'Trà', 6, UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ftea.png?alt=media', @enable),
            (UUID_TO_BIN('ea6fbbd7-89ad-11ee-bef9-a85e45c41921'), 'Nước trái cây', 7, UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fjuice.png?alt=media', @enable);





-- Supermarket
INSERT INTO `saving_hour_market`.`supermarket` (`id`, `status`, `name`, `phone`)
--     VALUES ('id', 'status', 'address', 'name', 'phone');
    VALUES  (UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921'), @enable, 'Vinmart+', '0904756354'),
            (UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921'), @enable, 'Co.opmart', '0904736452'),
            (UUID_TO_BIN('accf028b-5541-11ee-8a50-a85e45c41921'), @enable, 'Satrafoods', '0904628495'),
            (UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921'), @enable, 'Bách hóa xanh', '0903636253'),
            (UUID_TO_BIN('accf0709-5541-11ee-8a50-a85e45c41921'), @enable, 'Vissan', '0905736451');


-- Supermarket Address
INSERT INTO `saving_hour_market`.`supermarket_address` (`id`, `address`, `supermarket_id`, `pickup_point_id`)
    VALUES  (UUID_TO_BIN('ec5e8c78-56dc-11ee-8a50-a85e45c41921'), '34 Đ. Nam Cao, Phường Tân Phú, Quận 9, Hồ Chí Minh', UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e2090-56dc-11ee-8a50-a85e45c41921'), '48 Cầu Xây,Tân Phú,Thủ Đức,Hồ Chí Minh', UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e8dca-56dc-11ee-8a50-a85e45c41921'), '191 Quang Trung, Hiệp Phú, Thủ Đức, Hồ Chí Minh', UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e1f3a-56dc-11ee-8a50-a85e45c41921'), '82 Ngô Quyền,Hiệp Phú,Quận 9,Hồ Chí Minh', UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6f09c8-89ad-11ee-bef9-a85e45c41921'), '702 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e8f16-56dc-11ee-8a50-a85e45c41921'), '172 Nguyễn Xiển,Trường Thạnh,Thủ Đức,Hồ Chí Minh', UUID_TO_BIN('accf028b-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e9073-56dc-11ee-8a50-a85e45c41921'), '25 Cầu Xây,Tân Phú,Thủ Đức,Hồ Chí Minh', UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e9414-56dc-11ee-8a50-a85e45c41921'), '344 Lê Văn Việt, Tăng Nhơn Phú B, Thủ Đức, Hồ Chí Minh', UUID_TO_BIN('accf0709-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5ea1b4-56dc-11ee-8a50-a85e45c41921'), '89/1A Bưng Ông Thoàn, Phú Hữu, Thủ Đức, Hồ Chí Minh', UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5ea361-56dc-11ee-8a50-a85e45c41921'), '8 Nguyễn Hoàng, An Phú, Thủ Đức, Hồ Chí Minh', UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf105d-5541-11ee-8a50-a85e45c41921'));




-- 'ec5e321c-56dc-11ee-8a50-a85e45c41921'
-- 'ec5e33d6-56dc-11ee-8a50-a85e45c41921'


-- Time frame
INSERT INTO `saving_hour_market`.`time_frame` (`id`, `from_hour`, `to_hour`, `status`, `allowable_deliver_method`)
--     VALUES ('id', 'day_of_week', 'from_hour', 'to_hour', 'status');
    VALUES  (UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), '19:00:00', '20:30:00', @enable, @PickupPoint),
            (UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), '21:00:00', '22:30:00', @enable, @PickupPoint),
            (UUID_TO_BIN('ec5e05ac-56dc-11ee-8a50-a85e45c41921'), '08:00:00', '09:30:00', @enable, @DoorToDoor),
            (UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), '10:00:00', '11:30:00', @enable, @DoorToDoor),
            (UUID_TO_BIN('ec5e0855-56dc-11ee-8a50-a85e45c41921'), '12:00:00', '13:30:00', @enable, @DoorToDoor),
            (UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), '14:00:00', '15:30:00', @enable, @DoorToDoor),
            (UUID_TO_BIN('ec5e1c52-56dc-11ee-8a50-a85e45c41921'), '16:00:00', '17:30:00', @enable, @DoorToDoor);






-- Order Group
INSERT INTO `saving_hour_market`.`order_group` (`id`, `deliver_date`, `time_frame_id`, `pickup_point_id`, `deliverer_id`, `product_consolidation_area_id`)
--     VALUES ('id', 'time_frame_id', 'pickup_point_id');
    VALUES
--          (UUID_TO_BIN('accf129e-5541-11ee-8a50-a85e45c41921'), '2023-09-19', UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null, null),
--             (UUID_TO_BIN('accf13f0-5541-11ee-8a50-a85e45c41921'), '2023-09-18', UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0be1-5541-11ee-8a50-a85e45c41921'), null),
--             (UUID_TO_BIN('accf15b0-5541-11ee-8a50-a85e45c41921'), '2023-09-19', UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null, null),
--             (UUID_TO_BIN('accf1749-5541-11ee-8a50-a85e45c41921'), '2023-09-19', UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), null, null),
--             (UUID_TO_BIN('accf187a-5541-11ee-8a50-a85e45c41921'), '2023-09-20', UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0f40-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf19db-5541-11ee-8a50-a85e45c41921'), '2023-09-19', UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf105d-5541-11ee-8a50-a85e45c41921'), null, null),
--             (UUID_TO_BIN('accf1baa-5541-11ee-8a50-a85e45c41921'), '2023-09-20', UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf105d-5541-11ee-8a50-a85e45c41921'), null, null),
--          second time frame
--             (UUID_TO_BIN('accf1f39-5541-11ee-8a50-a85e45c41921'), '2023-09-18', UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null, null),
--             (UUID_TO_BIN('accf20d1-5541-11ee-8a50-a85e45c41921'), '2023-09-17', UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0be1-5541-11ee-8a50-a85e45c41921'), null),
--             (UUID_TO_BIN('accf2205-5541-11ee-8a50-a85e45c41921'), '2023-09-18', UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null, null),
--             (UUID_TO_BIN('accf26cb-5541-11ee-8a50-a85e45c41921'), '2023-09-17', UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0f40-5541-11ee-8a50-a85e45c41921'), null),
--             (UUID_TO_BIN('accf2846-5541-11ee-8a50-a85e45c41921'), '2023-09-18', UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf105d-5541-11ee-8a50-a85e45c41921'), null, null),
--             (UUID_TO_BIN('accf29d6-5541-11ee-8a50-a85e45c41921'), '2023-09-17', UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf117b-5541-11ee-8a50-a85e45c41921'), null);
-- dummy order group
    --  No deliverer
            (UUID_TO_BIN('a4e3cae1-78cf-11ee-a832-a85e45c41921'), @orderDateForOrderGroup, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null, null),
--             (UUID_TO_BIN('a4e3cc1d-78cf-11ee-a832-a85e45c41921'), '2023-11-20', UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null, null),
            (UUID_TO_BIN('a4e3cdbb-78cf-11ee-a832-a85e45c41921'), @orderDateForOrderGroup, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e3d067-78cf-11ee-a832-a85e45c41921'), @orderDateForOrderGroup, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null, null),
            (UUID_TO_BIN('a4e3d18e-78cf-11ee-a832-a85e45c41921'),  @orderDateForOrderGroup, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
    -- Have deliverer
            (UUID_TO_BIN('16fd4f45-8078-11ee-bef9-a85e45c41921'), @orderDateForOrderGroup, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd4d4b-8078-11ee-bef9-a85e45c41921'), @orderDateForOrderGroup, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921')),
    -- No deliverer but packaged
            (UUID_TO_BIN('16fdbd2c-8078-11ee-bef9-a85e45c41921'), @orderDateForFirstOrderGroupForAssignDeliver, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdbde6-8078-11ee-bef9-a85e45c41921'), @orderDateForSecondOrderGroupForAssignDeliver, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdbe9d-8078-11ee-bef9-a85e45c41921'), @orderDateForThirdOrderGroupForAssignDeliver, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
    -- success 2 first - fail 2 last
            (UUID_TO_BIN('ea6a14b1-89ad-11ee-bef9-a85e45c41921'), '2023-11-19', UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
    -- success all (month 10)
            (UUID_TO_BIN('accf2391-5541-11ee-8a50-a85e45c41921'), '2023-10-17', UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'));



-- Order Batch
INSERT INTO `saving_hour_market`.`order_batch` (`id`, `deliver_date`, `average_latitude`, `average_longitude`, `deliverer_id`, `time_frame_id`, `product_consolidation_area_id`)
--     VALUES (`id`, `district`, `deliver_date`, `deliverer_id`);
    VALUES
--             (UUID_TO_BIN('ec5def3a-56dc-11ee-8a50-a85e45c41921'), '2023-09-19', 0, 0, null, null, null),
--             (UUID_TO_BIN('ec5df0fa-56dc-11ee-8a50-a85e45c41921'), '2023-09-19', 0, 0, null, null, null),
--             (UUID_TO_BIN('ec5df219-56dc-11ee-8a50-a85e45c41921'), '2023-09-19', 0, 0, null, null, null),
--             (UUID_TO_BIN('ec5df327-56dc-11ee-8a50-a85e45c41921'), '2023-09-19', 0, 0, null, null, null),
--             (UUID_TO_BIN('ec5df442-56dc-11ee-8a50-a85e45c41921'), '2023-09-20', 0, 0, null, null, null),
--             (UUID_TO_BIN('ec5df557-56dc-11ee-8a50-a85e45c41921'), '2023-09-20', 0, 0, null, null, null),
--             (UUID_TO_BIN('ec5df668-56dc-11ee-8a50-a85e45c41921'), '2023-09-20', 0, 0, null, null, null),
--             (UUID_TO_BIN('ec5df810-56dc-11ee-8a50-a85e45c41921'), '2023-09-21', 0, 0, null, null, null),
--             (UUID_TO_BIN('ec5df929-56dc-11ee-8a50-a85e45c41921'), '2023-09-21', 0, 0, null, null, null),
-- dummy order_batch for order
            (UUID_TO_BIN('16fd46ef-8078-11ee-bef9-a85e45c41921'), @orderDateForBatchGroup, 10.78167, 106.741843, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6cf39c-89ad-11ee-bef9-a85e45c41921'), @orderDateForBatchGroup, 10.826586, 106.81510, null, UUID_TO_BIN('ec5e0855-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd4b5c-8078-11ee-bef9-a85e45c41921'), @orderDateForBatchGroup, 10.77341, 106.76333, UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e05ac-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd48ef-8078-11ee-bef9-a85e45c41921'), @orderDateForBatchGroup, 10.79592, 106.74515, UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdbc6e-8078-11ee-bef9-a85e45c41921'), @orderDateForBatchGroup, 10.78528, 106.75698, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea694273-89ad-11ee-bef9-a85e45c41921'), '2023-11-19', 10.79592, 106.74515, UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'));




-- Product
INSERT INTO `saving_hour_market`.`product` (`id`, `name`, `unit`, `price_listed`, `description`, `status`, `product_sub_category_id`, `supermarket_id`)
--     VALUES (`id`, `name`, `price`, `price_original`, `quantity`, `expired_date`, `description`, `image_url`, `status`, `product_category_id`, `supermarket_id`);
    VALUES  (UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 'Nước giặt Omo 2,9L', 'túi', 200000, @OmoDescription, @enable, UUID_TO_BIN('accf4547-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e38e3-56dc-11ee-8a50-a85e45c41921'), 'Nước xả vải Comfort hương nước hoa 3,8L', 'túi', 260000, @NuocXaComfort, @enable, UUID_TO_BIN('accf4547-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6e1233-89ad-11ee-bef9-a85e45c41921'), 'Nước giặt Ariel sen nhài túi 3.7kg', 'túi', 300000, @NuocGiatArielDescription, @enable, UUID_TO_BIN('accf4547-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf028b-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6e1e5e-89ad-11ee-bef9-a85e45c41921'), 'Nước giặt Lix hoa anh đào túi 2.4kg', 'túi', 90000, @NuocGiatLixDescription, @enable, UUID_TO_BIN('accf4547-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf028b-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6e29aa-89ad-11ee-bef9-a85e45c41921'), 'Nước giặt Walch lavender túi 2L', 'túi', 200000, @NuocGiatLavenderDescription, @enable, UUID_TO_BIN('accf4547-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf028b-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6e7441-89ad-11ee-bef9-a85e45c41921'), 'Nước rửa chén Earth Choice chanh 500ml', 'chai', 135000, @NuocRuaChenEarthChoiceDescription, @enable, UUID_TO_BIN('ea6d53d6-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6e8010-89ad-11ee-bef9-a85e45c41921'), 'Nước rửa chén Gift trà chanh 800g', 'chai', 32000, @NuocRuaChenGiftDescription, @enable, UUID_TO_BIN('ea6d53d6-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6eedcf-89ad-11ee-bef9-a85e45c41921'), 'Nước lau sàn Power 100 thiên nhiên 3.8kg', 'chai', 95000, @NuocPower100Description, @enable, UUID_TO_BIN('ea6d7645-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6efe32-89ad-11ee-bef9-a85e45c41921'), 'Nước lau sàn Select lily 3.6L', 'chai', 84000, @NuocSelectLilyDescription, @enable, UUID_TO_BIN('ea6d7645-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6f5e5b-89ad-11ee-bef9-a85e45c41921'), 'Nước tẩy Duck đậm đặc 700ml', 'chai', 40000, @NuocTayDuckDescription, @enable, UUID_TO_BIN('ea6d814d-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6f7d41-89ad-11ee-bef9-a85e45c41921'), 'Nước tẩy nhà tắm SWAT 1L', 'chai', 35000, @NuocTaySWATDescription, @enable, UUID_TO_BIN('ea6d814d-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf2c1d-5541-11ee-8a50-a85e45c41921'), 'Chả Giò Tôm Cua 500g', 'bịch', 75000, @ChaGioTomCuaDescription, @enable, UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0709-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 'Giò Heo Xông Khói 500g', 'bịch', 115000, @GioHeoXongKhoi, @enable, UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0709-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), 'Kem Wall’s Oreo hộp 750ml', 'hộp', 100000, @KemWallOreo, @enable, UUID_TO_BIN('accf4210-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e3b8f-56dc-11ee-8a50-a85e45c41921'), 'Kem Yukimi Daifuku Matcha 270ml', 'hộp', 80000, @KemYukimiMatcha, @enable, UUID_TO_BIN('accf4210-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 'Bột Milo Protomalt hũ 400g', 'hũ', 78000, @BotMilo, @enable, UUID_TO_BIN('accf4320-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf32f7-5541-11ee-8a50-a85e45c41921'), 'Nho mẫu đơn nội địa Trung 500g', '500g', 70000, @NhoMauDon, @enable, UUID_TO_BIN('accf3fdf-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf343c-5541-11ee-8a50-a85e45c41921'), '1 lốc sữa chua Vinamilk nha đam (4 hộp)', 'lốc', 56000, @SuaChuaVinamilk, @enable, UUID_TO_BIN('accf4320-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), '1 lốc hộp sữa tươi Vinamilk có đường (4 hộp)', 'lốc', 35000, @SuaTuoiVinamilk, @enable, UUID_TO_BIN('accf4320-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 'Sữa tắm Lifebuoy Vitamin 800g', 'chai', 170000, @SuaTamLifeBoy, @enable, UUID_TO_BIN('accf442f-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e3ced-56dc-11ee-8a50-a85e45c41921'), 'Sữa tắm Xmen sạch khuẩn detox 630g', 'chai', 185000, @SuaTamXmenDetox, @enable, UUID_TO_BIN('accf442f-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf377f-5541-11ee-8a50-a85e45c41921'), 'Nem Lụi 300g', 'bịch', 60000, @NemLui, @enable, UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0709-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e432f-56dc-11ee-8a50-a85e45c41921'), 'Nem bò tiêu xanh 400g', 'bịch', 85000, @NemBoTieuXanh, @enable, UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0709-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e3a42-56dc-11ee-8a50-a85e45c41921'), 'Phô mai viên Hoa Doanh 300g', 'bịch', 55000, @PhoMaiVienHoaDanh, @enable, UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3897-5541-11ee-8a50-a85e45c41921'), 'Táo Pink Lady nhập khẩu New Zealand 1kg', '1kg', 70000, @TaoPinkLady, @enable, UUID_TO_BIN('accf3fdf-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf39b0-5541-11ee-8a50-a85e45c41921'), 'Thùng 30 gói mì Omachi lẩu tôm', 'thùng', 215000, @MiLauTomOmachi, @enable, UUID_TO_BIN('accf4875-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf028b-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e3e40-56dc-11ee-8a50-a85e45c41921'), 'Thùng 30 gói mì Hảo Hảo hương vị lẩu kim chi', 'thùng', 110000, @MiHaoHaoKimChi, @enable, UUID_TO_BIN('accf4875-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3ac4-5541-11ee-8a50-a85e45c41921'), '1 lốc Strongbow Appple Ciders Gold (6 lon)', 'lốc', 105000, @StrongbowAppleGold, @enable, UUID_TO_BIN('accf4656-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf028b-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e4012-56dc-11ee-8a50-a85e45c41921'), 'Thùng 24 lon bia Heineken Silver', 'thùng', 390000, @BiaHeineken, @enable, UUID_TO_BIN('accf4656-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea708ef6-89ad-11ee-bef9-a85e45c41921'), 'Trà tâm sen đặc biệt Đại Gia 200g', 'gói', 125000, @TraTamSenDaiGiaDescription, @enable, UUID_TO_BIN('ea6fa014-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea70a03f-89ad-11ee-bef9-a85e45c41921'), 'Trà cung đình Huế gói 500g', 'gói', 75000, @TraCungDinhHueDescription, @enable, UUID_TO_BIN('ea6fa014-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea70c2ef-89ad-11ee-bef9-a85e45c41921'), 'Nước ép táo Marigold hộp 1L', 'hộp', 66000, @NuocEpTaoMarigoldDescription, @enable, UUID_TO_BIN('ea6fbbd7-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea70d5e1-89ad-11ee-bef9-a85e45c41921'), 'Nước ép lựu táo Vfresh hộp 1L', 'hộp', 67000, @NuocEpLuuTaoVfreshDescription, @enable, UUID_TO_BIN('ea6fbbd7-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 'Há Cảo Mini Cầu Tre Gói 500G', 'bịch', 75000, @HaCaoMiniCauTre, @enable, UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf028b-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 'Bông trang điểm Silcot hộp 82 miếng', 'hộp', 40000, @BongTrangDiemSilcot, @enable, UUID_TO_BIN('accf4766-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e41d8-56dc-11ee-8a50-a85e45c41921'), 'Sáp dưỡng ẩm Vaseline 50ml', 'hũ', 60000, @sapVaseline, @enable, UUID_TO_BIN('accf4766-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e3596-56dc-11ee-8a50-a85e45c41921'), 'Xà lách lolo 1kg', '1kg', 49000, @XaLachLolo, @enable, UUID_TO_BIN('ec5e1ddc-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e3778-56dc-11ee-8a50-a85e45c41921'), 'Cải thảo 1kg', '1kg', 21000, @CaiThao, @enable, UUID_TO_BIN('ec5e1ddc-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921'));


-- Product image
INSERT INTO `saving_hour_market`.`product_image` (`id`, `image_url`, `product_id`)
--      VALUES (`id`, `image_url`, `product_id`)
--  Nước giặt Omo 2,9L
    VALUES  (UUID_TO_BIN('a4e38eb7-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-giat-omo.jpeg?alt=media', UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e3b8cb-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-giat-omo-2.jpg?alt=media', UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e3b9fa-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-giat-omo-3.jpg?alt=media', UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921')),
--  Nước xả vải Comfort hương nước hoa 3,8L batch
            (UUID_TO_BIN('a4e38c04-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-xa-vai-comfort.jpg?alt=media', UUID_TO_BIN('ec5e38e3-56dc-11ee-8a50-a85e45c41921')),
--  Nước giặt Ariel sen nhài túi 3.7kg
            (UUID_TO_BIN('ea6d9f06-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-giat-ariel.jpg?alt=media', UUID_TO_BIN('ea6e1233-89ad-11ee-bef9-a85e45c41921')),
--  Nước giặt Lix hoa anh đào túi 2.4kg
            (UUID_TO_BIN('ea6dab7d-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-giat-Lix-hoa-anh-dao.jpg?alt=media', UUID_TO_BIN('ea6e1e5e-89ad-11ee-bef9-a85e45c41921')),
--  Nước giặt Walch lavender túi 2L
            (UUID_TO_BIN('ea6dccd7-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-giat-walch-lavender.jpg?alt=media', UUID_TO_BIN('ea6e29aa-89ad-11ee-bef9-a85e45c41921')),
--  Nước rửa chén Earth Choice chanh 500ml
            (UUID_TO_BIN('ea6e3459-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-rua-chen-earth-choice-huong-chanh.jpg?alt=media', UUID_TO_BIN('ea6e7441-89ad-11ee-bef9-a85e45c41921')),
--  Nước rửa chén Gift trà chanh 800g
            (UUID_TO_BIN('ea6e406b-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-rua-chen-gift-tra-chanh.jpg?alt=media', UUID_TO_BIN('ea6e8010-89ad-11ee-bef9-a85e45c41921')),
--  Nước lau sàn Power 100 thiên nhiên 3.8kg
            (UUID_TO_BIN('ea6e8d85-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-lau-san-power-100-thien-nhien.jpg?alt=media', UUID_TO_BIN('ea6eedcf-89ad-11ee-bef9-a85e45c41921')),
--  Nước lau sàn Select lily 3.6L
            (UUID_TO_BIN('ea6e98dd-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-lau-san-select-lily.jpg?alt=media', UUID_TO_BIN('ea6efe32-89ad-11ee-bef9-a85e45c41921')),
--  Nước tẩy Duck đậm đặc 700ml
            (UUID_TO_BIN('ea6f15b5-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-tay-duck.jpg?alt=media', UUID_TO_BIN('ea6f5e5b-89ad-11ee-bef9-a85e45c41921')),
--  Nước tẩy nhà tắm SWAT 1L
            (UUID_TO_BIN('ea6f36f7-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-tay-nha-tam-swat.jpg?alt=media', UUID_TO_BIN('ea6f7d41-89ad-11ee-bef9-a85e45c41921')),
--  Chả Giò Tôm Cua 500g
            (UUID_TO_BIN('a4e38d2e-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fcha-gio-tom-cua-500g.jpg?alt=media', UUID_TO_BIN('accf2c1d-5541-11ee-8a50-a85e45c41921')),
--  Giò Heo Xông Khói 500g
            (UUID_TO_BIN('a4e38fdd-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fgio_heo_xong_khoi.jpg?alt=media', UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921')),
--  Kem Wall’s Oreo hộp 750ml
            (UUID_TO_BIN('a4e3914b-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fkem-walls-oreo-hop.jpg?alt=media', UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921')),
--  Kem Yukimi Daifuku Matcha 270ml
            (UUID_TO_BIN('a4e39274-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fkem-yukimi-daifuku-matcha.jpg?alt=media', UUID_TO_BIN('ec5e3b8f-56dc-11ee-8a50-a85e45c41921')),
--  Bột Milo Protomalt hũ 400g
            (UUID_TO_BIN('a4e39395-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbot-milo-protomalt.jpg?alt=media', UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921')),
--  Nho mẫu đơn nội địa Trung 500g
            (UUID_TO_BIN('a4e394b7-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnho_mau_don.jpg?alt=media', UUID_TO_BIN('accf32f7-5541-11ee-8a50-a85e45c41921')),
--  2 lốc sữa chua Vinamilk nha đam (8 hộp)
            (UUID_TO_BIN('a4e3976d-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fsua-chua-vinamilk-nha-dam.jpg?alt=media', UUID_TO_BIN('accf343c-5541-11ee-8a50-a85e45c41921')),
-- 1 lốc hộp sữa tươi Vinamilk có đường (4 hộp)
            (UUID_TO_BIN('a4e398a4-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fsua-tuoi-vinamilk-co-duong.jpg?alt=media', UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921')),
-- Sữa tắm Lifebuoy Vitamin 800g
            (UUID_TO_BIN('a4e399c7-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fsua-tam-lifeboy.jpg?alt=media', UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921')),
-- Sữa tắm Xmen sạch khuẩn detox 630g
            (UUID_TO_BIN('a4e39aed-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fsua-tam-xmen-sach-khuan-detox.jpg?alt=media', UUID_TO_BIN('ec5e3ced-56dc-11ee-8a50-a85e45c41921')),
-- Nem Lụi 300g
            (UUID_TO_BIN('a4e39c16-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnem-lui.jpg?alt=media', UUID_TO_BIN('accf377f-5541-11ee-8a50-a85e45c41921')),
-- Nem bò tiêu xanh 400g
            (UUID_TO_BIN('a4e39f05-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnem-bo-tieu-xanh.jpg?alt=media', UUID_TO_BIN('ec5e432f-56dc-11ee-8a50-a85e45c41921')),
-- Phô mai viên Hoa Doanh 300g
            (UUID_TO_BIN('a4e39da8-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fpho-mai-vien-hoa-doanh.jpg?alt=media', UUID_TO_BIN('ec5e3a42-56dc-11ee-8a50-a85e45c41921')),
-- Táo Pink Lady nhập khẩu New Zealand 1kg
            (UUID_TO_BIN('a4e3a032-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ftao-pinklady.jpg?alt=media', UUID_TO_BIN('accf3897-5541-11ee-8a50-a85e45c41921')),
-- Thùng 30 gói mì Omachi lẩu tôm
            (UUID_TO_BIN('a4e3a15a-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fthung-mi-omachi-lau-tom.jpg?alt=media', UUID_TO_BIN('accf39b0-5541-11ee-8a50-a85e45c41921')),
-- Thùng 30 gói mì Hảo Hảo hương vị lẩu kim chi
            (UUID_TO_BIN('a4e3a285-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fthung-mi-hao-hao-kim-chi.jpg?alt=media', UUID_TO_BIN('ec5e3e40-56dc-11ee-8a50-a85e45c41921')),
-- 1 lốc Strongbow Appple Ciders Gold (6 lon)
            (UUID_TO_BIN('a4e3a3b1-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fstrongbow-apple-cider.jpg?alt=media', UUID_TO_BIN('accf3ac4-5541-11ee-8a50-a85e45c41921')),
-- Thùng 24 lon bia Heineken Silver
            (UUID_TO_BIN('a4e3a4ec-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fthung-bia-heineken.jpg?alt=media', UUID_TO_BIN('ec5e4012-56dc-11ee-8a50-a85e45c41921')),
-- Trà tâm sen đặc biệt Đại Gia 200g
            (UUID_TO_BIN('ea6fc673-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ftra-tam-sen-dai-gia.jpg?alt=media', UUID_TO_BIN('ea708ef6-89ad-11ee-bef9-a85e45c41921')),
-- Trà cung đình Huế gói 500g
            (UUID_TO_BIN('ea6fe613-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Ftra-cung-dinh-hue.jpg?alt=media', UUID_TO_BIN('ea70a03f-89ad-11ee-bef9-a85e45c41921')),
-- Nước ép táo Marigold hộp 1L
            (UUID_TO_BIN('ea6ff64b-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-ep-tao-marigold.jpg?alt=media', UUID_TO_BIN('ea70c2ef-89ad-11ee-bef9-a85e45c41921')),
-- Nước ép lựu táo Vfresh hộp 1L
            (UUID_TO_BIN('ea7013be-89ad-11ee-bef9-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fnuoc-ep-luu-tao-vfresh.jpg?alt=media', UUID_TO_BIN('ea70d5e1-89ad-11ee-bef9-a85e45c41921')),
-- Há Cảo Mini Cầu Tre Gói 500G
            (UUID_TO_BIN('a4e3a611-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fha-cao-mini.jpg?alt=media', UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921')),
-- Bông trang điểm Silcot hộp 82 miếng
            (UUID_TO_BIN('a4e3a78d-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbong-tay-trang-silicot.jpg?alt=media', UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921')),
-- Sáp dưỡng ẩm Vaseline 50ml
            (UUID_TO_BIN('a4e3a8bb-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fsap-duong-am-vaseline.jpg?alt=media', UUID_TO_BIN('ec5e41d8-56dc-11ee-8a50-a85e45c41921')),
-- Xà lách lolo 1kg
            (UUID_TO_BIN('a4e3aa45-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fxa-lach-lolo.jpg?alt=media', UUID_TO_BIN('ec5e3596-56dc-11ee-8a50-a85e45c41921')),
-- Cải thảo 1kg
            (UUID_TO_BIN('a4e3b720-78cf-11ee-a832-a85e45c41921'), 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fcai-thao.jpg?alt=media', UUID_TO_BIN('ec5e3778-56dc-11ee-8a50-a85e45c41921'));



-- Product batch
--  Nước giặt Omo 2,9L
SET @NuocGiatOmoFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 45 DAY),'%Y-%m-%d');
SET @NuocGiatOmoSecondBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 45 DAY),'%Y-%m-%d');
SET @NuocGiatOmoThirdBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');
SET @NuocGiatOmoFourthBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 45 DAY),'%Y-%m-%d');

--  Nước xả vải Comfort hương nước hoa 3,8L batch
SET @NuocXaVaiComfortFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');

--  Nước giặt Ariel sen nhài túi 3.7kg
SET @NuocGiatArielFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');

--  Nước giặt Lix hoa anh đào túi 2.4kg
SET @NuocGiatLixFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');

--  Nước giặt Walch lavender túi 2L
SET @NuocGiatLavenderFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');

--  Nước rửa chén Earth Choice chanh 500ml
SET @EarthChoiceFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');

--  Nước rửa chén Gift trà chanh 800g
SET @GiftFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');

--  Nước lau sàn Power 100 thiên nhiên 3.8kg
SET @Power100FirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');

--  Nước lau sàn Select lily 3.6L
SET @SelectLilyFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');

--  Nước tẩy Duck đậm đặc 700ml
SET @DuckFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 45 DAY),'%Y-%m-%d');

--  Nước tẩy nhà tắm SWAT 1L
SET @SwatFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 45 DAY),'%Y-%m-%d');

--  Chả Giò Tôm Cua 500g (2023-11-20)
SET @ChaGioTomCuaFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 15 DAY),'%Y-%m-%d');

--  Giò Heo Xông Khói 500g
SET @GioHeoXongKhoiFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d');

--  Kem Wall’s Oreo hộp 750ml
SET @KemWallOreoFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d');
SET @KemWallOreoSecondBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 25 DAY),'%Y-%m-%d');
SET @KemWallOreoThirdBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d');

--  Kem Yukimi Daifuku Matcha 270ml
SET @KemYukimiFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 25 DAY),'%Y-%m-%d');

--  Bột Milo Protomalt hũ 400g
SET @BotMiloFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 15 DAY),'%Y-%m-%d');

--  Nho mẫu đơn nội địa Trung 500g
SET @NhoMauDonFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 23 DAY),'%Y-%m-%d');

--  2 lốc sữa chua Vinamilk nha đam (8 hộp)
SET @SuaChuaVinamilkFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 25 DAY),'%Y-%m-%d');

-- 1 lốc hộp sữa tươi Vinamilk có đường (4 hộp)
SET @SuaTuoiVinamilkFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 24 DAY),'%Y-%m-%d');

-- Sữa tắm Lifebuoy Vitamin 800g
SET @SuaTamLifeBuoyVitaminFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 45 DAY),'%Y-%m-%d');

-- Sữa tắm Xmen sạch khuẩn detox 630g
SET @SuaTamXmenDetoxFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 40 DAY),'%Y-%m-%d');

-- Nem Lụi 300g
SET @NemLuiFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 25 DAY),'%Y-%m-%d');

-- Nem bò tiêu xanh 400g
SET @NemBoTieuXanhFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 21 DAY),'%Y-%m-%d');

-- Phô mai viên Hoa Doanh 300g
SET @PhoMaiVienHoaDanhFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d');

-- Táo Pink Lady nhập khẩu New Zealand 1kg
SET @TaoPinkLadyFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 22 DAY),'%Y-%m-%d');

-- Thùng 30 gói mì Omachi lẩu tôm
SET @ThungMiOmachiLauTomFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d');

-- Thùng 30 gói mì Hảo Hảo hương vị lẩu kim chi
SET @ThungMiHaoHaoKimChiFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 24 DAY),'%Y-%m-%d');

-- 1 lốc Strongbow Appple Ciders Gold (6 lon)
SET @LocStrongbowAppleGoldFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d');

-- Trà tâm sen đặc biệt Đại Gia 200g
SET @TraTamSenFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d');

-- Trà cung đình Huế gói 500g
SET @TraCungDinhHueFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d');

-- Nước ép táo Marigold hộp 1L
SET @NuocEpTaoMarigoldFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 8 DAY),'%Y-%m-%d');

-- Nước ép lựu táo Vfresh hộp 1L
SET @NuocEpTaoVfreshFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 8 DAY),'%Y-%m-%d');

-- Thùng 24 lon bia Heineken Silver
SET @ThungBiaLonHeinekenFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 25 DAY),'%Y-%m-%d');

-- Há Cảo Mini Cầu Tre Gói 500G
SET @HaCaoMiniCauTreFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d');

-- Bông trang điểm Silcot hộp 82 miếng
SET @BongTrangDiemSilcotFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 53 DAY),'%Y-%m-%d');

-- Sáp dưỡng ẩm Vaseline 50ml
SET @SapDuongAmVaslineFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 51 DAY),'%Y-%m-%d');

-- Xà lách lolo 1kg
SET @XaLachLoloFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 15 DAY),'%Y-%m-%d');

-- Cải thảo 1kg
SET @CaiThaoFirstBatchDate = DATE_FORMAT((CURDATE() + INTERVAL 16 DAY),'%Y-%m-%d');


INSERT INTO `saving_hour_market`.`product_batch` (`id`, `price`, `price_original`, `quantity`, `selling_date`, `expired_date`, `product_id`,`supermarket_address_id`)
--     VALUES (`id`, `price`, `price_original`, `quantity`, `expired_date`, `product_id`,`supermarket_address_id`)
--  Nước giặt Omo 2,9L
    VALUES  (UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921'), 159000, 130000, 50, '2023-11-04 00:00:00', @NuocGiatOmoFirstBatchDate, UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8c78-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5eb3ce-56dc-11ee-8a50-a85e45c41921'), 159000, 130000, 25, '2023-11-04 00:00:00', @NuocGiatOmoSecondBatchDate, UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e2090-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5eb531-56dc-11ee-8a50-a85e45c41921'), 149000, 120000, 25, '2023-11-04 00:00:00', @NuocGiatOmoThirdBatchDate, UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e2090-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5eb87e-56dc-11ee-8a50-a85e45c41921'), 159000, 130000, 20, '2023-11-04 00:00:00', @NuocGiatOmoFourthBatchDate, UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea1b4-56dc-11ee-8a50-a85e45c41921')),
--  Nước xả vải Comfort hương nước hoa 3,8L batch
            (UUID_TO_BIN('ec5ea6b7-56dc-11ee-8a50-a85e45c41921'), 210000, 180000, 25, '2023-10-25 00:00:00', @NuocXaVaiComfortFirstBatchDate, UUID_TO_BIN('ec5e38e3-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea1b4-56dc-11ee-8a50-a85e45c41921')),
--  Nước giặt Ariel sen nhài túi 3.7kg
            (UUID_TO_BIN('ea6ddce7-89ad-11ee-bef9-a85e45c41921'), 265000, 230000, 20, '2023-10-30 00:00:00', @NuocGiatArielFirstBatchDate, UUID_TO_BIN('ea6e1233-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e8f16-56dc-11ee-8a50-a85e45c41921')),
--  Nước giặt Lix hoa anh đào túi 2.4kg
            (UUID_TO_BIN('ea6de914-89ad-11ee-bef9-a85e45c41921'), 75000, 59000, 20, '2023-10-30 00:00:00', @NuocGiatLixFirstBatchDate, UUID_TO_BIN('ea6e1e5e-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e8f16-56dc-11ee-8a50-a85e45c41921')),
--  Nước giặt Walch lavender túi 2L
            (UUID_TO_BIN('ea6df41a-89ad-11ee-bef9-a85e45c41921'), 165000, 145000, 20, '2023-10-30 00:00:00', @NuocGiatLavenderFirstBatchDate, UUID_TO_BIN('ea6e29aa-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e8f16-56dc-11ee-8a50-a85e45c41921')),
--  Nước rửa chén Earth Choice chanh 500ml
            (UUID_TO_BIN('ea6e4ade-89ad-11ee-bef9-a85e45c41921'), 116000, 100000, 30, '2023-10-30 00:00:00', @EarthChoiceFirstBatchDate, UUID_TO_BIN('ea6e7441-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e9073-56dc-11ee-8a50-a85e45c41921')),
--  Nước rửa chén Gift trà chanh 800g
            (UUID_TO_BIN('ea6e57b2-89ad-11ee-bef9-a85e45c41921'), 27000, 23500, 30, '2023-10-30 00:00:00', @GiftFirstBatchDate, UUID_TO_BIN('ea6e8010-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e9073-56dc-11ee-8a50-a85e45c41921')),
--  Nước lau sàn Power 100 thiên nhiên 3.8kg
            (UUID_TO_BIN('ea6ec13a-89ad-11ee-bef9-a85e45c41921'), 80000, 70000, 30, '2023-10-30 00:00:00', @Power100FirstBatchDate, UUID_TO_BIN('ea6eedcf-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e2090-56dc-11ee-8a50-a85e45c41921')),
--  Nước lau sàn Select lily 3.6L
            (UUID_TO_BIN('ea6ece6c-89ad-11ee-bef9-a85e45c41921'), 75000, 66000, 30, '2023-10-30 00:00:00', @SelectLilyFirstBatchDate, UUID_TO_BIN('ea6efe32-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e2090-56dc-11ee-8a50-a85e45c41921')),
--  Nước tẩy Duck đậm đặc 700ml
            (UUID_TO_BIN('ea6f4793-89ad-11ee-bef9-a85e45c41921'), 33000, 28000, 30, '2023-10-30 00:00:00', @DuckFirstBatchDate, UUID_TO_BIN('ea6f5e5b-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6f09c8-89ad-11ee-bef9-a85e45c41921')),
--  Nước tẩy nhà tắm SWAT 1L
            (UUID_TO_BIN('ea6f539e-89ad-11ee-bef9-a85e45c41921'), 31000, 26000, 30, '2023-10-30 00:00:00', @SwatFirstBatchDate, UUID_TO_BIN('ea6f7d41-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6f09c8-89ad-11ee-bef9-a85e45c41921')),
--  Chả Giò Tôm Cua 500g
            (UUID_TO_BIN('ec5ea831-56dc-11ee-8a50-a85e45c41921'), 55000, 48000, 15, '2023-10-15 00:00:00', @ChaGioTomCuaFirstBatchDate, UUID_TO_BIN('accf2c1d-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e9414-56dc-11ee-8a50-a85e45c41921')),
--  Giò Heo Xông Khói 500g
            (UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921'), 90000, 75000, 10, '2023-10-10 00:00:00', @GioHeoXongKhoiFirstBatchDate, UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e9414-56dc-11ee-8a50-a85e45c41921')),
--  Kem Wall’s Oreo hộp 750ml
            (UUID_TO_BIN('ec5eab5f-56dc-11ee-8a50-a85e45c41921'), 75000, 62000, 25, '2023-10-20 00:00:00', @KemWallOreoFirstBatchDate, UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8dca-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5ebcb3-56dc-11ee-8a50-a85e45c41921'), 80000, 68000, 25, '2023-11-01 00:00:00', @KemWallOreoSecondBatchDate, UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8dca-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5ec37a-56dc-11ee-8a50-a85e45c41921'), 75000, 62000, 25, '2023-10-24 00:00:00', @KemWallOreoThirdBatchDate, UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e1f3a-56dc-11ee-8a50-a85e45c41921')),
--  Kem Yukimi Daifuku Matcha 270ml
            (UUID_TO_BIN('ec5eacbb-56dc-11ee-8a50-a85e45c41921'), 60000, 50000, 30, '2023-10-10 00:00:00', @KemYukimiFirstBatchDate, UUID_TO_BIN('ec5e3b8f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8dca-56dc-11ee-8a50-a85e45c41921')),
--  Bột Milo Protomalt hũ 400g
            (UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921'), 60000, 49000, 30, '2023-10-10 00:00:00', @BotMiloFirstBatchDate, UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8dca-56dc-11ee-8a50-a85e45c41921')),
--  Nho mẫu đơn nội địa Trung 500g
            (UUID_TO_BIN('ec5e869e-56dc-11ee-8a50-a85e45c41921'), 51000, 40000, 10, '2023-10-01 00:00:00', @NhoMauDonFirstBatchDate, UUID_TO_BIN('accf32f7-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea361-56dc-11ee-8a50-a85e45c41921')),
--  2 lốc sữa chua Vinamilk nha đam (8 hộp)
            (UUID_TO_BIN('ec5eaf69-56dc-11ee-8a50-a85e45c41921'), 42000, 35000, 10, '2023-10-05 00:00:00', @SuaChuaVinamilkFirstBatchDate, UUID_TO_BIN('accf343c-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e9073-56dc-11ee-8a50-a85e45c41921')),
-- 1 lốc hộp sữa tươi Vinamilk có đường (4 hộp)
            (UUID_TO_BIN('ec5eb268-56dc-11ee-8a50-a85e45c41921'), 25000, 21000, 15, '2023-10-01 00:00:00', @SuaTuoiVinamilkFirstBatchDate, UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea1b4-56dc-11ee-8a50-a85e45c41921')),
-- Sữa tắm Lifebuoy Vitamin 800g
            (UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921'), 145000, 120000, 10, '2023-11-05 00:00:00', @SuaTamLifeBuoyVitaminFirstBatchDate, UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8dca-56dc-11ee-8a50-a85e45c41921')),
-- Sữa tắm Xmen sạch khuẩn detox 630g
            (UUID_TO_BIN('ec5e4627-56dc-11ee-8a50-a85e45c41921'), 155000, 130000, 25, '2023-11-10 00:00:00', @SuaTamXmenDetoxFirstBatchDate, UUID_TO_BIN('ec5e3ced-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8c78-56dc-11ee-8a50-a85e45c41921')),
-- Nem Lụi 300g
            (UUID_TO_BIN('ec5e4897-56dc-11ee-8a50-a85e45c41921'), 42000, 35000, 15, '2023-10-10 00:00:00', @NemLuiFirstBatchDate, UUID_TO_BIN('accf377f-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e9414-56dc-11ee-8a50-a85e45c41921')),
-- Nem bò tiêu xanh 400g
            (UUID_TO_BIN('ec5e49f8-56dc-11ee-8a50-a85e45c41921'), 65000, 55000, 15, '2023-10-25 00:00:00', @NemBoTieuXanhFirstBatchDate, UUID_TO_BIN('ec5e432f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e9414-56dc-11ee-8a50-a85e45c41921')),
-- Phô mai viên Hoa Doanh 300g
            (UUID_TO_BIN('ec5e4b66-56dc-11ee-8a50-a85e45c41921'), 42000, 34000, 20, '2023-10-05 00:00:00', @PhoMaiVienHoaDanhFirstBatchDate, UUID_TO_BIN('ec5e3a42-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e9414-56dc-11ee-8a50-a85e45c41921')),
-- Táo Pink Lady nhập khẩu New Zealand 1kg
            (UUID_TO_BIN('ec5e4cbe-56dc-11ee-8a50-a85e45c41921'), 51000, 42000, 15, '2023-10-01 00:00:00', @TaoPinkLadyFirstBatchDate, UUID_TO_BIN('accf3897-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e9073-56dc-11ee-8a50-a85e45c41921')),
-- Thùng 30 gói mì Omachi lẩu tôm
            (UUID_TO_BIN('ec5e4e60-56dc-11ee-8a50-a85e45c41921'), 185000, 155000, 10, '2023-10-19 00:00:00', @ThungMiOmachiLauTomFirstBatchDate, UUID_TO_BIN('accf39b0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8f16-56dc-11ee-8a50-a85e45c41921')),
-- Thùng 30 gói mì Hảo Hảo hương vị lẩu kim chi
            (UUID_TO_BIN('ec5e4fce-56dc-11ee-8a50-a85e45c41921'), 95000, 80000, 25, '2023-11-01 00:00:00', @ThungMiHaoHaoKimChiFirstBatchDate, UUID_TO_BIN('ec5e3e40-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea361-56dc-11ee-8a50-a85e45c41921')),
-- 1 lốc Strongbow Appple Ciders Gold (6 lon)
            (UUID_TO_BIN('ec5e744a-56dc-11ee-8a50-a85e45c41921'), 88000, 75000, 20, '2023-10-20 00:00:00', @LocStrongbowAppleGoldFirstBatchDate, UUID_TO_BIN('accf3ac4-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8f16-56dc-11ee-8a50-a85e45c41921')),
-- Thùng 24 lon bia Heineken Silver
            (UUID_TO_BIN('ec5e77a5-56dc-11ee-8a50-a85e45c41921'), 340000, 300000, 15, '2023-11-01 00:00:00', @ThungBiaLonHeinekenFirstBatchDate, UUID_TO_BIN('ec5e4012-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e9073-56dc-11ee-8a50-a85e45c41921')),
-- Trà tâm sen đặc biệt Đại Gia 200g
            (UUID_TO_BIN('ea70342a-89ad-11ee-bef9-a85e45c41921'), 105000, 88000, 10, '2023-11-01 00:00:00', @TraTamSenFirstBatchDate, UUID_TO_BIN('ea708ef6-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6f09c8-89ad-11ee-bef9-a85e45c41921')),
-- Trà cung đình Huế gói 500g
            (UUID_TO_BIN('ea7044bc-89ad-11ee-bef9-a85e45c41921'), 66000, 60000, 20, '2023-11-01 00:00:00', @TraCungDinhHueFirstBatchDate, UUID_TO_BIN('ea70a03f-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6f09c8-89ad-11ee-bef9-a85e45c41921')),
-- Nước ép táo Marigold hộp 1L
            (UUID_TO_BIN('ea7061f6-89ad-11ee-bef9-a85e45c41921'), 60000, 55000, 15, '2023-11-01 00:00:00', @NuocEpTaoMarigoldFirstBatchDate, UUID_TO_BIN('ea70c2ef-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e9073-56dc-11ee-8a50-a85e45c41921')),
-- Nước ép lựu táo Vfresh hộp 1L
            (UUID_TO_BIN('ea706eb7-89ad-11ee-bef9-a85e45c41921'), 61000, 56000, 15, '2023-11-01 00:00:00', @NuocEpTaoVfreshFirstBatchDate, UUID_TO_BIN('ea70d5e1-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e9073-56dc-11ee-8a50-a85e45c41921')),
-- Há Cảo Mini Cầu Tre Gói 500G
            (UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921'), 58000, 49000, 15, '2023-10-01 00:00:00', @HaCaoMiniCauTreFirstBatchDate, UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8f16-56dc-11ee-8a50-a85e45c41921')),
-- Bông trang điểm Silcot hộp 82 miếng
            (UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921'), 31000, 27000, 10, '2023-11-25 00:00:00', @BongTrangDiemSilcotFirstBatchDate, UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8c78-56dc-11ee-8a50-a85e45c41921')),
-- Sáp dưỡng ẩm Vaseline 50ml
            (UUID_TO_BIN('ec5e8083-56dc-11ee-8a50-a85e45c41921'), 50000, 42000, 25, '2023-11-26 00:00:00', @SapDuongAmVaslineFirstBatchDate, UUID_TO_BIN('ec5e41d8-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8dca-56dc-11ee-8a50-a85e45c41921')),
-- Xà lách lolo 1kg
            (UUID_TO_BIN('ec5e8385-56dc-11ee-8a50-a85e45c41921'), 40000, 34000, 15, '2023-10-20 00:00:00', @XaLachLoloFirstBatchDate, UUID_TO_BIN('ec5e3596-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e8c78-56dc-11ee-8a50-a85e45c41921')),
-- Cải thảo 1kg
            (UUID_TO_BIN('ec5e84dd-56dc-11ee-8a50-a85e45c41921'), 18000, 16000, 10, '2023-10-25 00:00:00', @CaiThaoFirstBatchDate, UUID_TO_BIN('ec5e3778-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea1b4-56dc-11ee-8a50-a85e45c41921'));








-- 'ec5e87ec-56dc-11ee-8a50-a85e45c41921'
-- 'ec5e894d-56dc-11ee-8a50-a85e45c41921'
-- 'ec5e8b2b-56dc-11ee-8a50-a85e45c41921'



-- Discount
INSERT INTO `saving_hour_market`.`discount` (`id`, `name`, `percentage`, `quantity`, `spent_amount_required`, `expired_date`, `status`, `image_url`, `product_category_id`)
--     VALUES (`id`, `name`, `percentage`, `quantity`, `spent_amount_required`, `expired_date`, `status`);
    VALUES
            -- Đồ uống category
            (UUID_TO_BIN('ec5e5994-56dc-11ee-8a50-a85e45c41921'), 'Giảm giá, Ưu Đãi 20%', 20, 50, 150000, DATE_FORMAT((CURDATE() + INTERVAL 30 DAY),'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbig-sale.jpg?alt=media', UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e68fd-56dc-11ee-8a50-a85e45c41921'), 'Giảm giá, Ưu Đãi 40%', 40, 40, 300000, DATE_FORMAT((CURDATE() + INTERVAL 25 DAY),'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbig-sale-2.jpg?alt=media', UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e6c43-56dc-11ee-8a50-a85e45c41921'), 'Giảm giá, Ưu Đãi 15%', 15, 40, 120000, DATE_FORMAT((CURDATE() + INTERVAL 35 DAY),'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbig-discount.jpg?alt=media', UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921')),
            -- Thực phẩm category
            (UUID_TO_BIN('accf51d6-5541-11ee-8a50-a85e45c41921'), 'Giảm giá, Ưu Đãi 20%', 20, 50, 150000, DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbig-sale-2.jpg?alt=media', UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e574e-56dc-11ee-8a50-a85e45c41921'), 'Giảm giá, Ưu Đãi 10%', 10, 40, 90000, '2023-09-20 00:00:00', @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2F10-discount.jpg?alt=media', UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf7135-5541-11ee-8a50-a85e45c41921'), 'Ưu Đãi 5%', 5, 100, 60000, DATE_FORMAT((CURDATE() + INTERVAL 25 DAY),'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fmega-sale.jpg?alt=media', UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf77a1-5541-11ee-8a50-a85e45c41921'), 'Ưu Đãi lớn - Giảm giá 20%', 20, 0, 200000, DATE_FORMAT((CURDATE() + INTERVAL 20 DAY),'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2F20-discount.jpg?alt=media', UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921')),
            -- Chăm sóc sức khỏe category
            (UUID_TO_BIN('ec5e5e8d-56dc-11ee-8a50-a85e45c41921'), 'Giảm giá, Ưu Đãi 20%', 20, 50, 150000, DATE_FORMAT((CURDATE() + INTERVAL 35 DAY),'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2F20-discount.jpg?alt=media', UUID_TO_BIN('accefe0d-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf6fdd-5541-11ee-8a50-a85e45c41921'), 'Tuần lễ vàng - Ưu Đãi lớn 25%', 25, 35, 250000, DATE_FORMAT((CURDATE() + INTERVAL 15 DAY),'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbig-discount.jpg?alt=media', UUID_TO_BIN('accefe0d-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e6f17-56dc-11ee-8a50-a85e45c41921'), 'Ưu Đãi 5%', 5, 100, 60000, DATE_FORMAT((CURDATE() + INTERVAL 30 DAY) ,'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fmega-sale.jpg?alt=media', UUID_TO_BIN('accefe0d-5541-11ee-8a50-a85e45c41921')),
            -- Vật tư vệ sinh category
            (UUID_TO_BIN('accf7525-5541-11ee-8a50-a85e45c41921'), 'Giảm giá bất ngờ - Ưu đãi 15%', 15, 25, 15000, '2023-09-20 00:00:00', @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fsuper-sale.jpg?alt=media', UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf52f8-5541-11ee-8a50-a85e45c41921'), 'Giảm giá, Ưu Đãi lớn 35%', 35, 40, 200000, DATE_FORMAT((CURDATE() + INTERVAL 15 DAY) ,'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fmega-sale.jpg?alt=media', UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e6233-56dc-11ee-8a50-a85e45c41921'), 'Giảm giá, Ưu Đãi sốc 25%', 25, 40, 150000, DATE_FORMAT((CURDATE() + INTERVAL 20 DAY) ,'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbig-sale-2.jpg?alt=media', UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5e65cb-56dc-11ee-8a50-a85e45c41921'), 'Giảm giá, Ưu Đãi 10%', 10, 40, 90000, DATE_FORMAT((CURDATE() + INTERVAL 30 DAY) ,'%Y-%m-%d'), @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbig-discount.jpg?alt=media', UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921'));
--             (UUID_TO_BIN('accf5414-5541-11ee-8a50-a85e45c41921'), 'Siêu Ưu Đãi Khuyến mãi 35%', 35, 25, 300000, '2023-10-20 00:00:00', @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fbig-sale.png?alt=media', null, UUID_TO_BIN('accf442f-5541-11ee-8a50-a85e45c41921')),


--             (UUID_TO_BIN('ec5e6db5-56dc-11ee-8a50-a85e45c41921'), 'Ưu Đãi 5%', 5, 100, 60000, '2023-11-20 00:00:00', @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fspecial-diascount-banner.png?alt=media', null, UUID_TO_BIN('accf3fdf-5541-11ee-8a50-a85e45c41921')),

--             (UUID_TO_BIN('ec5e713f-56dc-11ee-8a50-a85e45c41921'), 'Ưu Đãi 5%', 5, 100, 60000, '2023-11-20 00:00:00', @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fspecial-diascount-banner.png?alt=media', null, UUID_TO_BIN('accf4656-5541-11ee-8a50-a85e45c41921')),

--             (UUID_TO_BIN('accf7392-5541-11ee-8a50-a85e45c41921'), 'Ưu Đãi Tháng 10 - Giảm giá 20%', 20, 80, 200000, '2023-11-01 00:00:00', @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fspecial-diascount-banner.png?alt=media', null, UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf765b-5541-11ee-8a50-a85e45c41921'), 'Ưu Đãi Tháng 8 - Giảm giá 20%', 20, 80, 200000, '2023-09-01 00:00:00', @enable, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fspecial-diascount-banner.png?alt=media', null, UUID_TO_BIN('accf3fdf-5541-11ee-8a50-a85e45c41921')),











-- Discount_Product_Category
-- INSERT INTO `saving_hour_market`.`discount_product_category` (`discount_id`, `product_category_id`)
-- --     VALUES (`discount_id`, `product_category_id`)
--     VALUES  (UUID_TO_BIN('accf51d6-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf51d6-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf6fdd-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf6fdd-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accefe0d-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf765b-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accefcee-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf7135-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf77a1-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf7525-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921'));


-- Discount_Product_Sub_Category
-- INSERT INTO `saving_hour_market`.`discount_product_sub_category` (`discount_id`, `product_sub_category_id`)
-- --     VALUES (`discount_id`, `product_sub_category_id`)
--     VALUES  (UUID_TO_BIN('accf5414-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf442f-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf5414-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4766-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf5414-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf7392-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4210-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf7392-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf40fe-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf52f8-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4656-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf52f8-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4875-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf7525-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3fdf-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf7525-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4547-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf7135-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3fdf-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf7135-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4656-5541-11ee-8a50-a85e45c41921'));


-- Order - old (have deliverer id)
-- INSERT INTO `saving_hour_market`.`orders` (`id`, `total_price`, `created_time`, `address_deliver`, `qr_code_url`, `status`, `customer_id`, `packager_id`, `deliverer_id`, `discount_id`, `order_group_id`)
-- --     VALUES (`id`, `total_price`, `created_time`, `address_deliver`, `qr_code_url`, `status`, `customer_id`, `packager_id`, `deliverer_id`, `discount_id`, `order_group_id`);
--     VALUES  (UUID_TO_BIN('accf7b01-5541-11ee-8a50-a85e45c41921'), 352000, '2023-09-19 14:20:00', '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', 'qr code url here', @success,
--                 UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4f95-5541-11ee-8a50-a85e45c41921'), null, null),
--
--             (UUID_TO_BIN('accf7c79-5541-11ee-8a50-a85e45c41921'), 278400, '2023-09-16 15:00:00', '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', 'qr code url here', @success,
--                 UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4f95-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf51d6-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf2391-5541-11ee-8a50-a85e45c41921')),
--
--             (UUID_TO_BIN('accf7dc4-5541-11ee-8a50-a85e45c41921'), 546000, '2023-09-16 15:00:00', '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', 'qr code url here', @cancel,
--                 UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, null, null, UUID_TO_BIN('accf2391-5541-11ee-8a50-a85e45c41921')),
--
--             (UUID_TO_BIN('ec5dcac6-56dc-11ee-8a50-a85e45c41921'), 67000, '2023-09-19 13:00:00', '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', 'qr code url here', @processing,
--                 UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, null, null, UUID_TO_BIN('accf2391-5541-11ee-8a50-a85e45c41921')),
--
--             (UUID_TO_BIN('ec5de351-56dc-11ee-8a50-a85e45c41921'), 216000, '2023-09-20 08:00:00', '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', 'qr code url here', @packaging,
--                 UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('accf2391-5541-11ee-8a50-a85e45c41921')),
--
--             (UUID_TO_BIN('ec5de6e9-56dc-11ee-8a50-a85e45c41921'), 111000, '2023-09-19 15:00:00', '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', 'qr code url here', @delivering,
--                 UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4f95-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf2391-5541-11ee-8a50-a85e45c41921')),
--
--             (UUID_TO_BIN('ec5debf5-56dc-11ee-8a50-a85e45c41921'), 304000, '2023-09-18 12:00:00', '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', 'qr code url here', @delivering,
--                 UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4f95-5541-11ee-8a50-a85e45c41921'), null, null);


-- Order new
INSERT INTO `saving_hour_market`.`orders` (`id`, `code`, `total_price`, `total_discount_price`, `shipping_fee`, `created_time`, `delivery_date`, `payment_method`, `delivery_method`, `payment_status`, `address_deliver`, `receiver_phone`, `receiver_name`, `latitude`, `longitude`, `qr_code_url`, `status`, `customer_id`, `packager_id`, `order_group_id`, `order_batch_id`, `time_frame_id`, `product_consolidation_area_id`, `pickup_point_id`, deliverer_id)
--     VALUES (`id`, `total_price`, `shipping_fee`, `created_time`, `delivery_date`, `payment_method`, `address_deliver`, `qr_code_url`, `status`, `customer_id`, `packager_id`, `order_group_id`, `order_batch_id`);
    VALUES  (UUID_TO_BIN('accf7b01-5541-11ee-8a50-a85e45c41921'), 'SHMORD171023000001', 352000, 77650, 19000, '2023-10-17 14:20:00','2023-10-19', @cod, @DoorToDoor, @paid, '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.827628, 106.721636, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Faccf7b01-5541-11ee-8a50-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),

--             (UUID_TO_BIN('ec5dcac6-56dc-11ee-8a50-a85e45c41921'), 53600, 13400, 16000, '2023-11-18 13:00:00', '2023-11-19 13:00:00', @vnpay, @DoorToDoor, @paid, '50 Lê Văn Việt, Hiệp Phú, Quận 9, Thành phố Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.847278, 106.776302, 'qr code url here', @processing,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5def3a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), null, null, null),
--
--             (UUID_TO_BIN('ec5de351-56dc-11ee-8a50-a85e45c41921'), 216000, 0, 0, '2023-11-18 08:00:00', '2023-11-17 19:00:00', @vnpay, @PickupPoint, @paid, null, null, null, null, null, 'qr code url here', @packaging,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf19db-5541-11ee-8a50-a85e45c41921'), null, null, null, null, null),


--  dummy order for order without any group
    --success status with discount (random discount)
            (UUID_TO_BIN('16fdd344-8078-11ee-bef9-a85e45c41921'), 'SHMORD181123000001', 344000, 11111, 16000, '2023-11-18', '2023-11-19', @cod, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2F16fdd344-8078-11ee-bef9-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdd404-8078-11ee-bef9-a85e45c41921'), 'SHMORD181123000002', 205000, 11111, 16000, '2023-11-18', '2023-11-19', @cod, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2F16fdd404-8078-11ee-bef9-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdd4bd-8078-11ee-bef9-a85e45c41921'), 'SHMORD181123000003', 140000, 11111, 16000, '2023-11-18', '2023-11-19', @cod, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2F16fdd4bd-8078-11ee-bef9-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
    --fail status
            (UUID_TO_BIN('16fdd91e-8078-11ee-bef9-a85e45c41921'), 'SHMORD181123000004', 60000, 0, 16000, '2023-11-18', '2023-11-19', @cod, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2F16fdd91e-8078-11ee-bef9-a85e45c41921.png?alt=media', @fail,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea690a79-89ad-11ee-bef9-a85e45c41921'), 'SHMORD181123000005', 60000, 0, 16000, '2023-11-18', '2023-11-19', @cod, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea690a79-89ad-11ee-bef9-a85e45c41921.png?alt=media', @fail,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
    --cancel status (for refund)
            (UUID_TO_BIN('ea725183-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000009'), 60000, 0, 16000, @orderCreateDateForOrderCancel, @orderDateForOrderCancel, @vnpay, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea725183-89ad-11ee-bef9-a85e45c41921.png?alt=media', @cancel,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea725256-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000010'), 60000, 0, 16000, @orderCreateDateForOrderCancel, @orderDateForOrderCancel, @vnpay, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea725256-89ad-11ee-bef9-a85e45c41921.png?alt=media', @cancel,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
    --processing status
            (UUID_TO_BIN('16fd9342-8078-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000012'), 304000, 0, 16000, @orderCreateDateForOrderSingleForProcessingStatus, @orderDateForOrderSingleForProcessingStatus, @vnpay, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2F16fd9342-8078-11ee-bef9-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('16fd9404-8078-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000013'), 91000, 0, 16000, @orderCreateDateForOrderSingleForProcessingStatus, @orderDateForOrderSingleForProcessingStatus, @vnpay, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2F16fd9404-8078-11ee-bef9-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, null, null, UUID_TO_BIN('ec5e0855-56dc-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('16fd94c6-8078-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000014'), 67000, 0, 16000, @orderCreateDateForOrderSingleForProcessingStatus, @orderDateForOrderSingleForProcessingStatus, @vnpay, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2F16fd94c6-8078-11ee-bef9-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
    --delivering status (for nguoigiaohang1 - ec5e00f7-56dc-11ee-8a50-a85e45c41921 + QR code)
            (UUID_TO_BIN('b0eebddf-dc69-4494-8217-03146ebbf7f1'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000009'), 118000, 0, 16000, @orderCreateDateForOrderSingleForDeliveringStatus, @orderDateForOrderSingleForDeliveringStatus, @vnpay, @DoorToDoor, @paid, '178 Phước Thiện, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fb0eebddf-dc69-4494-8217-03146ebbf7f1.png?alt=media', @delivering,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('39011105-9258-4f6c-bc5e-1faca44abfee'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000010'), 106000, 0, 16000, @orderCreateDateForOrderSingleForDeliveringStatus, @orderDateForOrderSingleForDeliveringStatus, @vnpay, @DoorToDoor, @paid, '188 Phước Thiện, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2F39011105-9258-4f6c-bc5e-1faca44abfee.png?alt=media', @delivering,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e0855-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('1b2eb7c3-e86a-4799-8877-828c2ac9c66f'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000011'), 115000, 0, 16000, @orderCreateDateForOrderSingleForDeliveringStatus, @orderDateForOrderSingleForDeliveringStatus, @vnpay, @DoorToDoor, @paid, '200 Phước Thiện, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84472, 106.82994, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2F1b2eb7c3-e86a-4799-8877-828c2ac9c66f.png?alt=media', @delivering,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e0855-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),

--  dummy order for run batching grouping (
        --  time frame: 10:00:00 - 11:30:00
        --  consolidation area: Đường N7, Tăng Nhơn Phú A, Thủ Đức, Hồ Chí Minh
        -- deliver date: Date after current date
            -- start old order recycle
            (UUID_TO_BIN('ec5debf5-56dc-11ee-8a50-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000001'), 304000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '81 Nguyễn Xiển, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84436, 106.82960, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fec5debf5-56dc-11ee-8a50-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ec5de6e9-56dc-11ee-8a50-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000002'), 111000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '39 Đường Số 275, Hiệp Phú, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84532, 106.78508, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fec5de6e9-56dc-11ee-8a50-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            -- end old order recycle
            (UUID_TO_BIN('a4e3c710-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000003'), 304000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '640 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84459, 106.82976, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3c710-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3bc3a-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000004'), 91000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, 'Hẻm 920 Nguyễn Xiển, Long Bình, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.85576, 106.83516, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3bc3a-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3bd5d-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000005'), 67000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '168 Phước Thiện, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84778, 106.84364, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3bd5d-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3be96-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000006'), 235000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '466 Lê Văn Việt, Tăng Nhơn Phú A, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84560, 106.79542, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3be96-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3c9b6-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000007'), 234000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '30 Đ. Số 102, Tăng Nhơn Phú A, Quận 9, Thành phố Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84804, 106.78815, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3c9b6-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3c0f2-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000008'), 217000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '94 Man Thiện, Tăng Nhơn Phú A, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.84816, 106.78724, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3c0f2-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),

            (UUID_TO_BIN('ea725daf-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000011'), 58000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '401 Hoàng Hữu Nam, Long Bình, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.87300, 106.81464, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea725daf-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea725e6d-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000012'), 58000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '31 Đ. 13, Long Bình, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.87588, 106.81654, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea725e6d-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea725fca-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000013'), 50000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '9/11 Đường 11, Long Bình, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.87517, 106.81635, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea725fca-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea7260a1-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000014'), 145000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '12 Đường Số 400, Tân Phú, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.87142, 106.80883, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea7260a1-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea72616d-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000015'), 31000, 0, 16000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @vnpay, @DoorToDoor, @paid, '560 Hoàng Hữu Nam, Long Bình, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.87725, 106.81584, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea72616d-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, null, UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),

        --  time frame: 14:00:00 - 15:30:00 (ec5e099f-56dc-11ee-8a50-a85e45c41921)
        --  consolidation area: Đường N7, Tăng Nhơn Phú A, Thủ Đức, Hồ Chí Minh (ec5dfa4a-56dc-11ee-8a50-a85e45c41921)
        --  deliver date: Date after current date
        --  order owner: La Dieu Van (accef4cc-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('ea7277c0-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000016'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '23 Lã Xuân Oai, Tăng Nhơn Phú A, Thủ Đức, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.84444, 106.78738, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea7277c0-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea7278a1-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000017'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '9 Trương Văn Thành, Hiệp Phú, Thủ Đức, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.84519, 106.78193, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea7278a1-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea727987-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000018'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '165 Lê Văn Việt, Hiệp Phú, Thủ Đức, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.84558, 106.77963, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea727987-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea727b0b-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000019'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '7 Lê Lợi, Hiệp Phú, Thủ Đức, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.84707, 106.77555, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea727b0b-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea727bce-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000020'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '46/6 Đường Tân Lập 2, Hiệp Phú, Quận 9, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.84796, 106.78087, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea727bce-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),

            (UUID_TO_BIN('ea727c93-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000021'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '16 Đường Số 154, Tân Phú, Thủ Đức, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.86768, 106.80554, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea727c93-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea727d54-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000022'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '264 Đường số 154, Long Thạnh Mỹ, Quận 9, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.86477, 106.81269, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea727d54-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea727e19-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000023'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '48 Đường Số 1, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.86872, 106.81621, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea727e19-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea727ed8-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000024'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '54 Đường Số 1A, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.86395, 106.81568, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea727ed8-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea727fa3-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000025'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '152 Hoàng Hữu Nam, Long Thạnh Mỹ, Quận 9, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.85667, 106.81358, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea727fa3-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),

            (UUID_TO_BIN('ea728065-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000026'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '428A Nguyễn Văn Tăng, Long Thạnh Mỹ, Quận 9, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.84155, 106.82744, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea728065-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea728122-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000027'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '4/1 Phước Thiện, Long Thạnh Mỹ, Quận 9, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.84783, 106.83201, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea728122-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea7281e5-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE()),'%d%m%y'), '000028'), 31000, 0, 19000, @orderCreateDateBatchingForGroup, @orderDateBatchingForGroup, @cod, @DoorToDoor, @unpaid, '125 Đường 15A, Long Bình, Quận 9, Hồ Chí Minh', '0901818618', 'La Dieu Van', 10.85052,106.84067, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea7281e5-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), null, null, UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
--  dummy order for batch group
    -- order batch id: '16fdbc6e-8078-11ee-bef9-a85e45c41921' (no deliverer + packaged)
    -- time frane: 10:00:00 - 11:30:00 (ec5e070b-56dc-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3c284-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000001'), 235000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '224 Nguyễn Thị Định, Bình Trưng Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.78563, 106.75665, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3c284-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fdbc6e-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea716bd0-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000014'), 126000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '4 Đường 29, Phường Bình Trưng Tây, Quận 2, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.78505, 106.75674, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea716bd0-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fdbc6e-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea7177d3-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000015'), 106000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '1 Đường Số 25, Bình Trưng Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.78516, 106.75755, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea7177d3-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fdbc6e-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),


    -- order batch id: 16fd46ef-8078-11ee-bef9-a85e45c41921 (no deliverer + packaged)
    -- time frame: 10:00:00 - 11:30:00 (ec5e070b-56dc-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3c3af-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000002'), 119000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '462 Mai Chí Thọ, Bình Khánh, Quận 2, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.78203, 106.74052, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3c3af-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fd46ef-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea720994-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000016'), 126000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '26 Mai Chí Thọ, An Khánh, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.78111, 106.74062, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea720994-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fd46ef-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea7212aa-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000017'), 155000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '21 Trịnh Văn Căn, Bình Khánh, An Khánh, Quận 2, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.78187, 106.74439, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea7212aa-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fd46ef-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e070b-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),

    -- order batch id: ea6cf39c-89ad-11ee-bef9-a85e45c41921 (no deliverer + packaged + far away)
    -- time frame: 12:00:00 - 13:30:00 (ec5e0855-56dc-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('ea6d4819-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000003'), 391000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '127 Lò Lu,Trường Thạnh,Thủ Đức,Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.82589, 106.81527, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6d4819-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ea6cf39c-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e0855-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea724557-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000018'), 265000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '22 Đường Số 3, Trường Thạnh, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.82756, 106.81646, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea724557-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ea6cf39c-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e0855-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea7247d5-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000019'), 165000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '64 Ích Thạnh,Trường Thạnh,Thủ Đức,Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.82631, 106.81357, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea7247d5-89ad-11ee-bef9-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ea6cf39c-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e0855-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),

    -- order batch id: 16fd4b5c-8078-11ee-bef9-a85e45c41921 (have deliverer)
    -- time frame: 08:00:00 - 09:30:00 (ec5e05ac-56dc-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3c4cf-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000004'), 304000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '133 Đồng Văn Cống, Thạnh Mỹ Lợi, Quận 2, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.77341, 106.76333, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3c4cf-78cf-11ee-a832-a85e45c41921.png?alt=media', @delivering,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fd4b5c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e05ac-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),

    -- order batch id: 16fd48ef-8078-11ee-bef9-a85e45c41921 (have deliverer)
    -- time frame: 14:00:00 - 15:30:00 (ec5e099f-56dc-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3c5ee-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000005'), 203000, 0, 16000, @orderCreateDateForBatchGroup, @orderDateForBatchGroup, @vnpay, @DoorToDoor, @paid, '91 Nguyễn Hoàng, An Phú, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.79592, 106.74515, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3c5ee-78cf-11ee-a832-a85e45c41921.png?alt=media', @delivering,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fd48ef-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),

    -- order batch id: ea694273-89ad-11ee-bef9-a85e45c41921 (success order - 2 first + fail order - 2 last)
            (UUID_TO_BIN('ea69ee3b-89ad-11ee-bef9-a85e45c41921'), 'SHMORD181123000012', 270000, 0, 16000, '2023-11-18 13:00:00', '2023-11-19', @vnpay, @DoorToDoor, @paid, '91 Nguyễn Hoàng, An Phú, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.79592, 106.74515, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea69ee3b-89ad-11ee-bef9-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ea694273-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea69f7dc-89ad-11ee-bef9-a85e45c41921'), 'SHMORD181123000013', 86000, 0, 16000, '2023-11-18 13:00:00', '2023-11-19', @vnpay, @DoorToDoor, @paid, '31 Đường số 29, An Phú, Quận 2, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.79978, 106.74767, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea69f7dc-89ad-11ee-bef9-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ea694273-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea6a0229-89ad-11ee-bef9-a85e45c41921'), 'SHMORD181123000014', 60000, 0, 16000, '2023-11-18 13:00:00', '2023-11-19', @vnpay, @DoorToDoor, @paid, '38 Đường Số 29, An Phú, Quận 2, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.79980, 106.74776, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6a0229-89ad-11ee-bef9-a85e45c41921.png?alt=media', @fail,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ea694273-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea6a0b53-89ad-11ee-bef9-a85e45c41921'), 'SHMORD181123000015', 60000, 0, 16000, '2023-11-18 13:00:00', '2023-11-19', @vnpay, @DoorToDoor, @paid, '80 Đường số 29, An Phú, Quận 2, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', 10.79981, 106.74782, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6a0b53-89ad-11ee-bef9-a85e45c41921.png?alt=media', @fail,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('ea694273-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e099f-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),


--  dummy order for order group (have deliverer + first two block is new processing order)
    --order group id: '16fd4d4b-8078-11ee-bef9-a85e45c41921'
    --pickup point: 857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh (accf0e1e-5541-11ee-8a50-a85e45c41921) -- time frame: '19:00:00', '20:30:00' (accf0876-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('ea6bf10b-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000006'), 196000, 0, 0, @orderCreateDateForOrderGroupHaveDelivererForNewProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6bf10b-89ad-11ee-bef9-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fd4d4b-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea6c12cc-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000007'), 197000, 0, 0, @orderCreateDateForOrderGroupHaveDelivererForNewProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6c12cc-89ad-11ee-bef9-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fd4d4b-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3f76b-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000008'), 344000, 0, 0, @orderCreateDateForOrderGroupHaveDeliverer, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3f76b-78cf-11ee-a832-a85e45c41921.png?alt=media', @delivering,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fd4d4b-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e3f88f-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000009'), 330000, 0, 0, @orderCreateDateForOrderGroupHaveDeliverer, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3f88f-78cf-11ee-a832-a85e45c41921.png?alt=media', @delivering,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fd4d4b-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),

    --order group id: '16fd4f45-8078-11ee-bef9-a85e45c41921'
    --pickup point: 857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh (accf0e1e-5541-11ee-8a50-a85e45c41921) -- time frame: '21:00:00', '22:30:00' (accf0996-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('ea6ce6f6-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000010'), 146000, 0, 0, @orderCreateDateForOrderGroupHaveDelivererForNewProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6ce6f6-89ad-11ee-bef9-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fd4f45-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ea6cd6ce-89ad-11ee-bef9-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000011'), 115000, 0, 0, @orderCreateDateForOrderGroupHaveDelivererForNewProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6cd6ce-89ad-11ee-bef9-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('16fd4f45-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3ea2a-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000012'), 200000, 0, 0, @orderCreateDateForOrderGroupHaveDeliverer, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3ea2a-78cf-11ee-a832-a85e45c41921.png?alt=media', @delivering,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fd4f45-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e3ebff-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 3 DAY),'%d%m%y'), '000013'), 304000, 0, 0, @orderCreateDateForOrderGroupHaveDeliverer, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3ebff-78cf-11ee-a832-a85e45c41921.png?alt=media', @delivering,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fd4f45-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfde4-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),


--  dummy order for order group
    --order group id: 'a4e3cae1-78cf-11ee-a832-a85e45c41921' (processing)
    --pickup point: Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh (accf0ac0-5541-11ee-8a50-a85e45c41921) -- time frame: '19:00:00', '20:30:00' (accf0876-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3d8af-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000001'), 235000, 0, 0, @orderCreateDateForOrderGroupForProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3d8af-78cf-11ee-a832-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3cae1-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3d9fb-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000002'), 217000, 0, 0, @orderCreateDateForOrderGroupForProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3d9fb-78cf-11ee-a832-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3cae1-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3dbd2-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000003'), 121000, 0, 0, @orderCreateDateForOrderGroupForProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3dbd2-78cf-11ee-a832-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3cae1-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3dd15-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000004'), 247000, 0, 0, @orderCreateDateForOrderGroupForProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3dd15-78cf-11ee-a832-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3cae1-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
    --order group id: 'a4e3cc1d-78cf-11ee-a832-a85e45c41921'
    --pickup point: Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh (accf0ac0-5541-11ee-8a50-a85e45c41921) -- time frame: '21:00:00', '22:30:00' (accf0996-5541-11ee-8a50-a85e45c41921)
--             (UUID_TO_BIN('a4e3df91-78cf-11ee-a832-a85e45c41921'), 208800, 139200, 0, '2023-11-18 13:00:00', '2023-11-20 13:00:00', @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'qr code url here', @processing,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3cc1d-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('a4e3e0c5-78cf-11ee-a832-a85e45c41921'), 208800, 139200, 0, '2023-11-18 13:00:00', '2023-11-20 13:00:00', @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'qr code url here', @processing,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3cc1d-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('a4e3e209-78cf-11ee-a832-a85e45c41921'), 208800, 139200, 0, '2023-11-18 13:00:00', '2023-11-20 13:00:00', @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'qr code url here', @processing,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3cc1d-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('a4e3e345-78cf-11ee-a832-a85e45c41921'), 208800, 139200, 0, '2023-11-18 13:00:00', '2023-11-20 13:00:00', @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'qr code url here', @processing,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3cc1d-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('a4e3e479-78cf-11ee-a832-a85e45c41921'), 208800, 139200, 0, '2023-11-18 13:00:00', '2023-11-20 13:00:00', @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'qr code url here', @processing,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3cc1d-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
    --order group id: 'a4e3d067-78cf-11ee-a832-a85e45c41921' (processing)
    --pickup point: 432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh (accf0d06-5541-11ee-8a50-a85e45c41921) -- time frame: '19:00:00', '20:30:00' (accf0876-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3ed59-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000005'), 243000, 0, 0, @orderCreateDateForOrderGroupForProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3ed59-78cf-11ee-a832-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3d067-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3eeab-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000006'), 100000, 0, 0, @orderCreateDateForOrderGroupForProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3eeab-78cf-11ee-a832-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3d067-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3efcb-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000007'), 235000, 0, 0, @orderCreateDateForOrderGroupForProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3efcb-78cf-11ee-a832-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3d067-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3f0f2-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 2 DAY),'%d%m%y'), '000008'), 217000, 0, 0, @orderCreateDateForOrderGroupForProcessingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3f0f2-78cf-11ee-a832-a85e45c41921.png?alt=media', @processing,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('a4e3d067-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
    --order group id: 'a4e3cdbb-78cf-11ee-a832-a85e45c41921' (have consolidation area)
    --consolidation area id: 'ec5dfa4a-56dc-11ee-8a50-a85e45c41921'
    --pickup point: Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh (accf0ac0-5541-11ee-8a50-a85e45c41921) -- time frame: '21:00:00', '22:30:00' (accf0996-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3e5a1-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000001'), 67000, 0, 0, @orderCreateDateForOrderGroupForPackingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3e5a1-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaging,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('a4e3cdbb-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3e73b-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000002'), 187000, 0, 0, @orderCreateDateForOrderGroupForPackingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3e73b-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaging,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('a4e3cdbb-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3e8dc-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000003'), 113000, 0, 0, @orderCreateDateForOrderGroupForPackingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3e8dc-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaging,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('a4e3cdbb-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
    --order group id: 'a4e3d18e-78cf-11ee-a832-a85e45c41921' (have consolidation area)
    --consolidation area id: 'ec5dfa4a-56dc-11ee-8a50-a85e45c41921'
    --pickup point: 432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh (accf0d06-5541-11ee-8a50-a85e45c41921) -- time frame: '21:00:00', '22:30:00' (accf0996-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3f3cb-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000004'), 97000, 0, 0, @orderCreateDateForOrderGroupForPackingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3f3cb-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaging,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('a4e3d18e-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('a4e3f500-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000005'), 233000, 0, 0, @orderCreateDateForOrderGroupForPackingOrder, @orderDateForOrderGroup, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3f500-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaging,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('a4e3d18e-78cf-11ee-a832-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
    --order group id: '16fdbd2c-8078-11ee-bef9-a85e45c41921' (have consolidation area + packaged)
    --consolidation area id: 'ec5dfa4a-56dc-11ee-8a50-a85e45c41921'
    --pickup point: 432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh (accf0d06-5541-11ee-8a50-a85e45c41921) -- time frame: '21:00:00', '22:30:00' (accf0996-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3f643-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000006'), 235000, 0, 0, @orderCreateDateForOrderGroupForPackagedOrder, @orderDateForFirstOrderGroupForAssignDeliver, @vnpay, @PickupPoint, @paid, '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3f643-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdbd2c-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ce198a9e-9d6f-11ee-88e1-02923cab4c75'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000009'), 90000, 0, 0, @orderCreateDateForOrderGroupForPackagedOrder, @orderDateForFirstOrderGroupForAssignDeliver, @vnpay, @PickupPoint, @paid, '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fce198a9e-9d6f-11ee-88e1-02923cab4c75.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdbd2c-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ce198baa-9d6f-11ee-88e1-02923cab4c75'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000010'), 145000, 0, 0, @orderCreateDateForOrderGroupForPackagedOrder, @orderDateForFirstOrderGroupForAssignDeliver, @vnpay, @PickupPoint, @paid, '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fce198baa-9d6f-11ee-88e1-02923cab4c75.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdbd2c-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
    --order group id: '16fdbde6-8078-11ee-bef9-a85e45c41921' (have consolidation area + packaged)
    --consolidation area id: 'ec5dfa4a-56dc-11ee-8a50-a85e45c41921'
    --pickup point: 432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh (accf0d06-5541-11ee-8a50-a85e45c41921) -- time frame: '19:00:00', '20:30:00' (accf0876-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3f216-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000007'), 304000, 0, 0, @orderCreateDateForOrderGroupForPackagedOrder, @orderDateForSecondOrderGroupForAssignDeliver, @vnpay, @PickupPoint, @paid, '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3f216-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdbde6-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ce1990c6-9d6f-11ee-88e1-02923cab4c75'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000011'), 159000, 0, 0, @orderCreateDateForOrderGroupForPackagedOrder, @orderDateForSecondOrderGroupForAssignDeliver, @vnpay, @PickupPoint, @paid, '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fce1990c6-9d6f-11ee-88e1-02923cab4c75.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdbde6-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ce1991ca-9d6f-11ee-88e1-02923cab4c75'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000012'), 145000, 0, 0, @orderCreateDateForOrderGroupForPackagedOrder, @orderDateForSecondOrderGroupForAssignDeliver, @vnpay, @PickupPoint, @paid, '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fce1991ca-9d6f-11ee-88e1-02923cab4c75.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdbde6-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), null),
    --order group id: '16fdbe9d-8078-11ee-bef9-a85e45c41921' (have consolidation area + packaged)
    --consolidation area id: 'ec5dfa4a-56dc-11ee-8a50-a85e45c41921'
    --pickup point: Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh (accf0ac0-5541-11ee-8a50-a85e45c41921) -- time frame: '19:00:00', '20:30:00' (accf0876-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('a4e3de53-78cf-11ee-a832-a85e45c41921'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000008'), 304000, 0, 0, @orderCreateDateForOrderGroupForPackagedOrder, @orderDateForThirdOrderGroupForAssignDeliver, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fa4e3de53-78cf-11ee-a832-a85e45c41921.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdbe9d-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ce1996f8-9d6f-11ee-88e1-02923cab4c75'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000013'), 159000, 0, 0, @orderCreateDateForOrderGroupForPackagedOrder, @orderDateForThirdOrderGroupForAssignDeliver, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fce1996f8-9d6f-11ee-88e1-02923cab4c75.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdbe9d-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('ce19980e-9d6f-11ee-88e1-02923cab4c75'), CONCAT('SHMORD', DATE_FORMAT((CURDATE() - INTERVAL 1 DAY),'%d%m%y'), '000014'), 145000, 0, 0, @orderCreateDateForOrderGroupForPackagedOrder, @orderDateForThirdOrderGroupForAssignDeliver, @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fce19980e-9d6f-11ee-88e1-02923cab4c75.png?alt=media', @packaged,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdbe9d-8078-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), null),
    --order group id: 'ea6a14b1-89ad-11ee-bef9-a85e45c41921' (success 2 first - fail 2 last)
    --consolidation area id: 'ec5dfa4a-56dc-11ee-8a50-a85e45c41921'
    --pickup point: Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh (accf0ac0-5541-11ee-8a50-a85e45c41921) -- time frame: '19:00:00', '20:30:00' (accf0876-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('ea6b0aec-89ad-11ee-bef9-a85e45c41921'), 'SHMORD101123000001', 105000, 11111, 0, '2023-11-10 13:00:00', '2023-11-19', @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6b0aec-89ad-11ee-bef9-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6a14b1-89ad-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6b17c8-89ad-11ee-bef9-a85e45c41921'), 'SHMORD101123000002', 111000, 11111, 0, '2023-11-10 13:00:00', '2023-11-19', @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6b17c8-89ad-11ee-bef9-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6a14b1-89ad-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea6b24f8-89ad-11ee-bef9-a85e45c41921'), 'SHMORD101123000003', 60000, 0, 0, '2023-11-10 13:00:00', '2023-11-19', @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6b24f8-89ad-11ee-bef9-a85e45c41921.png?alt=media', @fail,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6a14b1-89ad-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6b450e-89ad-11ee-bef9-a85e45c41921'), 'SHMORD101123000004', 60000, 0, 0, '2023-11-10 13:00:00', '2023-11-19', @vnpay, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Fea6b450e-89ad-11ee-bef9-a85e45c41921.png?alt=media', @fail,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6a14b1-89ad-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
    --order group id: 'accf2391-5541-11ee-8a50-a85e45c41921'
    --consolidation area id: 'ec5dfa4a-56dc-11ee-8a50-a85e45c41921'
    --pickup point: 857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh (accf0e1e-5541-11ee-8a50-a85e45c41921) -- time frame: '21:00:00', '22:30:00' (accf0996-5541-11ee-8a50-a85e45c41921)
            (UUID_TO_BIN('accf7c79-5541-11ee-8a50-a85e45c41921'), 'SHMORD141023000001', 203000, 10000, 0, '2023-10-14 15:00:00', '2023-10-17', @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Faccf7c79-5541-11ee-8a50-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf2391-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf7dc4-5541-11ee-8a50-a85e45c41921'), 'SHMORD141023000002', 273000, 10000, 0, '2023-10-14 13:00:00', '2023-10-17', @vnpay, @PickupPoint, @paid, '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/Order_QR_code%2Faccf7dc4-5541-11ee-8a50-a85e45c41921.png?alt=media', @success,
             UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf2391-5541-11ee-8a50-a85e45c41921'), null, UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'));

            -- Start old order recycle
--             (UUID_TO_BIN('a4e3cf39-78cf-11ee-a832-a85e45c41921'), 208800, 0, 0, '2023-11-10 13:00:00', '2023-11-19', @cod, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'qr code url here', @success,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6a14b1-89ad-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('a4e3bfca-78cf-11ee-a832-a85e45c41921'), 208800, 0, 0, '2023-11-10 13:00:00', '2023-11-19', @cod, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'qr code url here', @success,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6a14b1-89ad-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('a4e3c832-78cf-11ee-a832-a85e45c41921'), 208800, 0, 0, '2023-11-10 13:00:00', '2023-11-19', @cod, @PickupPoint, @paid, 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh', '0902828618', 'Luu Gia Vinh', null, null, 'qr code url here', @success,
--              UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf4d19-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6a14b1-89ad-11ee-bef9-a85e45c41921'), null, UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dfa4a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e00f7-56dc-11ee-8a50-a85e45c41921'));
            -- End old order recycle

-- Order discount
INSERT INTO `saving_hour_market`.`discount_order` (`discount_id`, `order_id`)
    VALUES  (UUID_TO_BIN('accf51d6-5541-11ee-8a50-a85e45c41921'),UUID_TO_BIN('accf7b01-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf6fdd-5541-11ee-8a50-a85e45c41921'),UUID_TO_BIN('accf7b01-5541-11ee-8a50-a85e45c41921')),

--             (UUID_TO_BIN('accf6fdd-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf7c79-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf51d6-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf7c79-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf7392-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf7c79-5541-11ee-8a50-a85e45c41921')),

--             (UUID_TO_BIN('accf77a1-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dcac6-56dc-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf52f8-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5dcac6-56dc-11ee-8a50-a85e45c41921'));
-- dummy for order
        --success status (random discount)
            (UUID_TO_BIN('accf51d6-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd344-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ec5e5994-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd344-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('accf7135-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd344-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('accf7525-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd344-8078-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('accf77a1-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd404-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ec5e5e8d-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd404-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ec5e6f17-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd404-8078-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('accf6fdd-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd4bd-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ec5e6f17-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd4bd-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ec5e574e-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('16fdd4bd-8078-11ee-bef9-a85e45c41921')),

-- dummy for order batch
        -- order batch id: ea694273-89ad-11ee-bef9-a85e45c41921 (success order - 2 first)
            (UUID_TO_BIN('accf51d6-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea69ee3b-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('accf7135-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea69ee3b-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ec5e6f17-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea69f7dc-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('accf77a1-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea69f7dc-89ad-11ee-bef9-a85e45c41921')),

-- dummy for order group
        --order group id: 'ea6a14b1-89ad-11ee-bef9-a85e45c41921' (success 2 first - fail 2 last)
            (UUID_TO_BIN('ec5e574e-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b0aec-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('accf7525-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b0aec-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ec5e574e-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b17c8-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('accf7135-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b17c8-89ad-11ee-bef9-a85e45c41921'));

-- Order Detail
INSERT INTO `saving_hour_market`.`order_detail` (`id`, `product_id`, `bought_quantity`, `product_price`, `product_original_price`, `order_id`)
--     VALUES (`id`, `product_id`, `bought_quantity`, `product_original_price`, `product_price`, `order_id`);
    VALUES  (UUID_TO_BIN('accf7ee5-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('accf7b01-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf8026-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), 1, 75000, 62000, UUID_TO_BIN('accf7b01-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf814e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf377f-5541-11ee-8a50-a85e45c41921'), 1, 42000, 35000, UUID_TO_BIN('accf7b01-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf8271-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('accf7b01-5541-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('accf8390-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf2c1d-5541-11ee-8a50-a85e45c41921'), 1, 55000, 48000, UUID_TO_BIN('accf7c79-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf84af-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 1, 58000, 49000, UUID_TO_BIN('accf7c79-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf864a-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('accf7c79-5541-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('accf8775-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3ac4-5541-11ee-8a50-a85e45c41921'), 1, 88000, 75000, UUID_TO_BIN('accf7dc4-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf88e1-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf39b0-5541-11ee-8a50-a85e45c41921'), 1, 185000, 155000, UUID_TO_BIN('accf7dc4-5541-11ee-8a50-a85e45c41921')),

--             (UUID_TO_BIN('ec5ddff7-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf343c-5541-11ee-8a50-a85e45c41921'), 1, 42000, 35000, UUID_TO_BIN('ec5dcac6-56dc-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('ec5de21a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), 1, 25000, 21000, UUID_TO_BIN('ec5dcac6-56dc-11ee-8a50-a85e45c41921')),

--             (UUID_TO_BIN('ec5de48d-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf39b0-5541-11ee-8a50-a85e45c41921'), 1, 185000, 155000, UUID_TO_BIN('ec5de351-56dc-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('ec5de5be-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ec5de351-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ec5de94e-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('ec5de6e9-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5dea86-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3897-5541-11ee-8a50-a85e45c41921'), 1, 51000, 42000, UUID_TO_BIN('ec5de6e9-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ec5ded18-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('ec5debf5-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ec5dee28-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('ec5debf5-56dc-11ee-8a50-a85e45c41921')),
-- dummy order detail
    -- for dummy order without any group
        --success status with discount (random discount)
            (UUID_TO_BIN('16fdc9f5-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e3778-56dc-11ee-8a50-a85e45c41921'), 1, 18000, 16000, UUID_TO_BIN('16fdd344-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fdcaac-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e432f-56dc-11ee-8a50-a85e45c41921'), 1, 65000, 55000, UUID_TO_BIN('16fdd344-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fdcc18-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf32f7-5541-11ee-8a50-a85e45c41921'), 1, 51000, 40000, UUID_TO_BIN('16fdd344-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fdccd1-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e38e3-56dc-11ee-8a50-a85e45c41921'), 1, 210000, 180000, UUID_TO_BIN('16fdd344-8078-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fdcd91-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e3b8f-56dc-11ee-8a50-a85e45c41921'), 1, 60000, 50000, UUID_TO_BIN('16fdd404-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fdce4a-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e3e40-56dc-11ee-8a50-a85e45c41921'), 1, 95000, 80000, UUID_TO_BIN('16fdd404-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fdcf01-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e41d8-56dc-11ee-8a50-a85e45c41921'), 1, 50000, 42000, UUID_TO_BIN('16fdd404-8078-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fdcfe7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e3596-56dc-11ee-8a50-a85e45c41921'), 1, 40000, 34000, UUID_TO_BIN('16fdd4bd-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fdd108-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), 1, 25000, 21000, UUID_TO_BIN('16fdd4bd-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fdd27c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), 1, 75000, 62000, UUID_TO_BIN('16fdd4bd-8078-11ee-bef9-a85e45c41921')),
        --fail status
            (UUID_TO_BIN('16fdd7ad-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('16fdd91e-8078-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fdd6ec-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('ea690a79-89ad-11ee-bef9-a85e45c41921')),
        --cancel status (for refund)
            (UUID_TO_BIN('ea724fae-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('ea725183-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea7250b6-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('ea725256-89ad-11ee-bef9-a85e45c41921')),
        --processing status
            (UUID_TO_BIN('16fda0df-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('16fd9342-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fda28e-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('16fd9342-8078-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fda36c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('16fd9404-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fdacff-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('16fd9404-8078-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fda454-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf343c-5541-11ee-8a50-a85e45c41921'), 1, 42000, 35000, UUID_TO_BIN('16fd94c6-8078-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('16fda52c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), 1, 25000, 21000, UUID_TO_BIN('16fd94c6-8078-11ee-bef9-a85e45c41921')),
        --delivering status (for nguoigiaohang1 + QR code)
            (UUID_TO_BIN('16fdb10c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 1, 58000, 49000, UUID_TO_BIN('b0eebddf-dc69-4494-8217-03146ebbf7f1')),
            (UUID_TO_BIN('16fdb1f7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('b0eebddf-dc69-4494-8217-03146ebbf7f1')),

            (UUID_TO_BIN('16fdb2d0-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), 1, 75000, 62000, UUID_TO_BIN('39011105-9258-4f6c-bc5e-1faca44abfee')),
            (UUID_TO_BIN('16fdb39f-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('39011105-9258-4f6c-bc5e-1faca44abfee')),

            (UUID_TO_BIN('16fdb473-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('1b2eb7c3-e86a-4799-8877-828c2ac9c66f')),
            (UUID_TO_BIN('16fdb542-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), 1, 25000, 21000, UUID_TO_BIN('1b2eb7c3-e86a-4799-8877-828c2ac9c66f')),


    -- for dummy order for batching
        --no deliverer
            (UUID_TO_BIN('a4e3f9b1-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3c710-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('a4e3d2b5-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3c710-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('a4e3d3d8-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('a4e3bc3a-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('a4e3d4f4-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('a4e3bc3a-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('a4e3d62a-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf343c-5541-11ee-8a50-a85e45c41921'), 1, 42000, 35000, UUID_TO_BIN('a4e3bd5d-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('a4e3d74a-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), 1, 25000, 21000, UUID_TO_BIN('a4e3bd5d-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('a4e3fae1-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('a4e3be96-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('a4e3fc06-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3be96-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('a4e3fd37-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3c9b6-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('a4e3fe5c-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), 1, 75000, 62000, UUID_TO_BIN('a4e3c9b6-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('a4e3ffb9-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3c0f2-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fbec2d-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 1, 58000, 49000, UUID_TO_BIN('a4e3c0f2-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('ea72594e-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 1, 58000, 49000, UUID_TO_BIN('ea725daf-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea725a16-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 1, 58000, 49000, UUID_TO_BIN('ea725e6d-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea725ad5-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e41d8-56dc-11ee-8a50-a85e45c41921'), 1, 50000, 42000, UUID_TO_BIN('ea725fca-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea725bf7-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('ea7260a1-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea725cec-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea72616d-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea726d4c-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea7277c0-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea726e11-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea7278a1-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea726ed7-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea727987-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea726fa2-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea727b0b-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea727065-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea727bce-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea727124-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea727c93-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea7271ea-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea727d54-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea7272a9-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea727e19-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea727367-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea727ed8-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea727427-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea727fa3-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea7274f1-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea728065-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea7275b8-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea728122-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea727677-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea7281e5-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fc07d2-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('a4e3c284-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc0a8a-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3c284-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('ea7129bf-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea70a03f-89ad-11ee-bef9-a85e45c41921'), 1, 66000, 60000, UUID_TO_BIN('ea716bd0-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea714657-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea70c2ef-89ad-11ee-bef9-a85e45c41921'), 1, 60000, 55000, UUID_TO_BIN('ea716bd0-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea71510d-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6e1e5e-89ad-11ee-bef9-a85e45c41921'), 1, 75000, 59000, UUID_TO_BIN('ea7177d3-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea716075-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6f7d41-89ad-11ee-bef9-a85e45c41921'), 1, 31000, 26000, UUID_TO_BIN('ea7177d3-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fc0cdd-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3ac4-5541-11ee-8a50-a85e45c41921'), 1, 88000, 75000, UUID_TO_BIN('a4e3c3af-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc0f1d-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('a4e3c3af-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('ea71c18a-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e432f-56dc-11ee-8a50-a85e45c41921'), 1, 65000, 55000, UUID_TO_BIN('ea720994-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea71cae9-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea70d5e1-89ad-11ee-bef9-a85e45c41921'), 1, 61000, 56000, UUID_TO_BIN('ea720994-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea71e5c3-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e41d8-56dc-11ee-8a50-a85e45c41921'), 1, 50000, 42000, UUID_TO_BIN('ea7212aa-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea71ef23-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea708ef6-89ad-11ee-bef9-a85e45c41921'), 1, 105000, 88000, UUID_TO_BIN('ea7212aa-89ad-11ee-bef9-a85e45c41921')),


            (UUID_TO_BIN('ea6d3e3a-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf32f7-5541-11ee-8a50-a85e45c41921'), 1, 51000, 40000, UUID_TO_BIN('ea6d4819-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea6d2282-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4012-56dc-11ee-8a50-a85e45c41921'), 1, 340000, 300000, UUID_TO_BIN('ea6d4819-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea72309e-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6e1233-89ad-11ee-bef9-a85e45c41921'), 1, 265000, 230000, UUID_TO_BIN('ea724557-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea72316f-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6e29aa-89ad-11ee-bef9-a85e45c41921'), 1, 165000, 145000, UUID_TO_BIN('ea7247d5-89ad-11ee-bef9-a85e45c41921')),

            --have deliverer
            (UUID_TO_BIN('16fc1134-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3c4cf-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc1324-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3c4cf-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc2099-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 1, 58000, 49000, UUID_TO_BIN('a4e3c5ee-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc22b7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3c5ee-78cf-11ee-a832-a85e45c41921')),

        --success order - 2 first + fail order - 2 last
            (UUID_TO_BIN('ea69a8e0-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('ea69ee3b-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea69b1e4-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e38e3-56dc-11ee-8a50-a85e45c41921'), 1, 210000, 180000, UUID_TO_BIN('ea69ee3b-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea69cda5-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2c1d-5541-11ee-8a50-a85e45c41921'), 1, 55000, 48000, UUID_TO_BIN('ea69f7dc-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea69d6eb-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('ea69f7dc-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea69de9a-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('ea6a0229-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea69e6ce-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('ea6a0b53-89ad-11ee-bef9-a85e45c41921')),


-- for dummy order for order group
        --order group id: 'a4e3cae1-78cf-11ee-a832-a85e45c41921'
            (UUID_TO_BIN('16fc24e6-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('a4e3d8af-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc2705-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3d8af-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc2916-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3d9fb-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc2afa-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 1, 58000, 49000, UUID_TO_BIN('a4e3d9fb-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc2d1e-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921'), 1, 31000, 27000, UUID_TO_BIN('a4e3dbd2-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc2efa-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('a4e3dbd2-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc3118-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3dd15-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc45fe-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3ac4-5541-11ee-8a50-a85e45c41921'), 1, 88000, 75000, UUID_TO_BIN('a4e3dd15-78cf-11ee-a832-a85e45c41921')),

        --order group id: '16fdbe9d-8078-11ee-bef9-a85e45c41921'
            (UUID_TO_BIN('16fc4846-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3de53-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc56ac-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3de53-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('ce1994f1-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('ce1996f8-9d6f-11ee-88e1-02923cab4c75')),

            (UUID_TO_BIN('ce1995f8-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('ce19980e-9d6f-11ee-88e1-02923cab4c75')),

        --order group id: 'a4e3cdbb-78cf-11ee-a832-a85e45c41921'
            (UUID_TO_BIN('16fc59c9-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf343c-5541-11ee-8a50-a85e45c41921'), 1, 42000, 35000, UUID_TO_BIN('a4e3e5a1-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc5bd1-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), 1, 25000, 21000, UUID_TO_BIN('a4e3e5a1-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc5e53-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf377f-5541-11ee-8a50-a85e45c41921'), 1, 42000, 35000, UUID_TO_BIN('a4e3e73b-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc607d-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3e73b-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc62ab-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), 1, 25000, 21000, UUID_TO_BIN('a4e3e8dc-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc64aa-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3ac4-5541-11ee-8a50-a85e45c41921'), 1, 88000, 75000, UUID_TO_BIN('a4e3e8dc-78cf-11ee-a832-a85e45c41921')),

        --order group id: '16fd4f45-8078-11ee-bef9-a85e45c41921' (first two block is new processing order)
            (UUID_TO_BIN('ea6cb6e1-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3897-5541-11ee-8a50-a85e45c41921'), 1, 51000, 42000, UUID_TO_BIN('ea6ce6f6-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea6c8929-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e3e40-56dc-11ee-8a50-a85e45c41921'), 1, 95000, 80000, UUID_TO_BIN('ea6ce6f6-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea6c77ba-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e432f-56dc-11ee-8a50-a85e45c41921'), 1, 65000, 55000, UUID_TO_BIN('ea6cd6ce-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea6c5897-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e41d8-56dc-11ee-8a50-a85e45c41921'), 1, 50000, 42000, UUID_TO_BIN('ea6cd6ce-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fc66db-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2c1d-5541-11ee-8a50-a85e45c41921'), 1, 55000, 48000, UUID_TO_BIN('a4e3ea2a-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc68c9-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3ea2a-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc703a-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3ebff-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc72b7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3ebff-78cf-11ee-a832-a85e45c41921')),


        --order group id: 'a4e3d067-78cf-11ee-a832-a85e45c41921'
            (UUID_TO_BIN('16fc83c4-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf39b0-5541-11ee-8a50-a85e45c41921'), 1, 185000, 155000, UUID_TO_BIN('a4e3ed59-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc86c7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 1, 58000, 49000, UUID_TO_BIN('a4e3ed59-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc88c8-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), 1, 75000, 62000, UUID_TO_BIN('a4e3eeab-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc8b00-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), 1, 25000, 21000, UUID_TO_BIN('a4e3eeab-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc8ce2-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('a4e3efcb-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc8f24-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3efcb-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fc9161-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3f0f2-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc9385-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921'), 1, 58000, 49000, UUID_TO_BIN('a4e3f0f2-78cf-11ee-a832-a85e45c41921')),

        --order group id: '16fdbde6-8078-11ee-bef9-a85e45c41921'
            (UUID_TO_BIN('16fc9608-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3f216-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc9918-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3f216-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('ce198ec9-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('ce1990c6-9d6f-11ee-88e1-02923cab4c75')),

            (UUID_TO_BIN('ce198fc8-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('ce1991ca-9d6f-11ee-88e1-02923cab4c75')),


        --order group id: 'a4e3d18e-78cf-11ee-a832-a85e45c41921'
            (UUID_TO_BIN('16fc9bcc-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2c1d-5541-11ee-8a50-a85e45c41921'), 1, 55000, 48000, UUID_TO_BIN('a4e3f3cb-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fc9e06-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf377f-5541-11ee-8a50-a85e45c41921'), 1, 42000, 35000, UUID_TO_BIN('a4e3f3cb-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fca04c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3ac4-5541-11ee-8a50-a85e45c41921'), 1, 88000, 75000, UUID_TO_BIN('a4e3f500-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fca2d9-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3f500-78cf-11ee-a832-a85e45c41921')),

        --order group id: '16fdbd2c-8078-11ee-bef9-a85e45c41921'
            (UUID_TO_BIN('16fca9de-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('a4e3f643-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fcac00-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3f643-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('ce19887b-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 1, 90000, 75000, UUID_TO_BIN('ce198a9e-9d6f-11ee-88e1-02923cab4c75')),

            (UUID_TO_BIN('ce19899d-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('ce198baa-9d6f-11ee-88e1-02923cab4c75')),

        --order group id: '16fd4d4b-8078-11ee-bef9-a85e45c41921' (first two block is new processing order)
            (UUID_TO_BIN('ea6bd3be-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('ea6bf10b-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea6bc4f3-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3897-5541-11ee-8a50-a85e45c41921'), 1, 51000, 42000, UUID_TO_BIN('ea6bf10b-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea6bb921-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e3ced-56dc-11ee-8a50-a85e45c41921'), 1, 155000, 130000, UUID_TO_BIN('ea6c12cc-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea6bac87-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf343c-5541-11ee-8a50-a85e45c41921'), 1, 42000, 35000, UUID_TO_BIN('ea6c12cc-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fcae1a-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 1, 159000, 130000, UUID_TO_BIN('a4e3f76b-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fcb02f-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf39b0-5541-11ee-8a50-a85e45c41921'), 1, 185000, 155000, UUID_TO_BIN('a4e3f76b-78cf-11ee-a832-a85e45c41921')),

            (UUID_TO_BIN('16fcb297-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf39b0-5541-11ee-8a50-a85e45c41921'), 1, 185000, 155000, UUID_TO_BIN('a4e3f88f-78cf-11ee-a832-a85e45c41921')),
            (UUID_TO_BIN('16fcb4bb-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 1, 145000, 120000, UUID_TO_BIN('a4e3f88f-78cf-11ee-a832-a85e45c41921')),

        --order group id: 'ea6a14b1-89ad-11ee-bef9-a85e45c41921' (success 2 first - fail 2 last)
            (UUID_TO_BIN('ea6a9321-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e3596-56dc-11ee-8a50-a85e45c41921'), 1, 40000, 34000, UUID_TO_BIN('ea6b0aec-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea6aa019-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e432f-56dc-11ee-8a50-a85e45c41921'), 1, 65000, 55000, UUID_TO_BIN('ea6b0aec-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea6aaca4-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e3b8f-56dc-11ee-8a50-a85e45c41921'), 1, 60000, 50000, UUID_TO_BIN('ea6b17c8-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea6accd3-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf32f7-5541-11ee-8a50-a85e45c41921'), 1, 51000, 40000, UUID_TO_BIN('ea6b17c8-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea6ae1b7-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('ea6b24f8-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea6afe79-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 1, 60000, 49000, UUID_TO_BIN('ea6b450e-89ad-11ee-bef9-a85e45c41921'));



INSERT INTO `saving_hour_market`.`order_detail_product_batch` (`id`, `bought_quantity`, `order_detail_id`, `product_batch_id`)
--     VALUES (`id`, `bought_quantity`, `order_detail_id`, `product_batch_id`)
    VALUES  (UUID_TO_BIN('a4e34831-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('accf7ee5-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e37581-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('accf8026-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5eab5f-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e37825-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('accf814e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e4897-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e37971-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('accf8271-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('a4e37a97-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('accf8390-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea831-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e37ce4-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('accf84af-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e37e21-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('accf864a-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('a4e37f43-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('accf8775-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e744a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e3806f-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('accf88e1-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e4e60-56dc-11ee-8a50-a85e45c41921')),

--             (UUID_TO_BIN('a4e381a1-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('ec5ddff7-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5eaf69-56dc-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('a4e382c5-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('ec5de21a-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5eb268-56dc-11ee-8a50-a85e45c41921')),

--             (UUID_TO_BIN('a4e38430-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('ec5de48d-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e4e60-56dc-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('a4e38565-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('ec5de5be-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('a4e3868c-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('ec5de94e-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e387af-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('ec5dea86-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e4cbe-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('a4e388cb-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('ec5ded18-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('a4e38abf-78cf-11ee-a832-a85e45c41921'), 1, UUID_TO_BIN('ec5dee28-56dc-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),
-- dummy order detail product batch
    -- for dummy order detail for order without any group
        --success with discount (random discount)
            (UUID_TO_BIN('16fdc23c-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdc9f5-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e84dd-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdc2f7-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdcaac-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e49f8-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdc3b1-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdcc18-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e869e-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdc4bd-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdccd1-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea6b7-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fdc585-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdcd91-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eacbb-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdc642-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdce4a-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4fce-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdc6fd-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdcf01-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e8083-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fdc7b8-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdcfe7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e8385-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdc86e-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdd108-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eb268-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdc937-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdd27c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eab5f-56dc-11ee-8a50-a85e45c41921')),

        --fail status
            (UUID_TO_BIN('16fdd579-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdd7ad-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fdd630-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdd6ec-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),
        --cancel status (for refund)
            (UUID_TO_BIN('ea724d7c-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea724fae-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea724e96-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea7250b6-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),
        --processing
            (UUID_TO_BIN('16fda7a7-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fda0df-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fda882-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fda28e-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fda957-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fda36c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdaa16-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdacff-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fdaae7-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fda454-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eaf69-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdabba-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fda52c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eb268-56dc-11ee-8a50-a85e45c41921')),
        --delivering status (for nguoigiaohang1 + QR code)
            (UUID_TO_BIN('16fdb612-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdb10c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdb6fd-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdb1f7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fdb7c5-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdb2d0-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eab5f-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdb918-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdb39f-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fdba1e-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdb473-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fdbb9a-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fdb542-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eb268-56dc-11ee-8a50-a85e45c41921')),


    -- for dummy order detail for order for batching
        --no deliverer
            (UUID_TO_BIN('16fcb963-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3f9b1-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcbb71-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3d2b5-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fcbd94-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3d3d8-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcbf6d-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3d4f4-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fcc1b4-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3d62a-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5eaf69-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcc3db-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3d74a-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5eb268-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fcc649-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3fae1-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcc872-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3fc06-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fccb2f-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3fd37-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fccd59-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3fe5c-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5eab5f-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fccf4b-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('a4e3ffb9-78cf-11ee-a832-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcd11a-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fbec2d-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea725524-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea72594e-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea7255e4-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea725a16-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea7256a7-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea725ad5-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e8083-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea7257a8-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea725bf7-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea72588b-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea725cec-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea7262e4-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea726d4c-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea7263cf-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea726e11-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea726495-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea726ed7-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea72655c-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea726fa2-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea72661f-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea727065-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea7266ea-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea727124-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea7267a9-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea7271ea-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea72686a-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea7272a9-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea72692d-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea727367-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea7269f0-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea727427-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea726ab1-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea7274f1-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea726bca-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea7275b8-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea726c89-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea727677-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fcd3ef-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc07d2-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcd60e-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc0a8a-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea70f46a-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea7129bf-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea7044bc-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea7100b8-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea714657-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea7061f6-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea710cbd-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea71510d-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6de914-89ad-11ee-bef9-a85e45c41921')),
            (UUID_TO_BIN('ea7118d3-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea716075-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6f539e-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('16fce23d-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc0cdd-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e744a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fce479-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc0f1d-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea71843d-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea71c18a-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e49f8-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea718f55-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea71cae9-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea706eb7-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea719bef-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea71e5c3-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e8083-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea71a690-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea71ef23-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea70342a-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea6cfe18-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6d3e3a-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e869e-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6d18cd-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6d2282-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e77a5-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea722ea5-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea72309e-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6ddce7-89ad-11ee-bef9-a85e45c41921')),

            (UUID_TO_BIN('ea722fc5-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea72316f-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ea6df41a-89ad-11ee-bef9-a85e45c41921')),

        --have deliverer
            (UUID_TO_BIN('16fce693-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc1134-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fce8ab-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc1324-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fceafe-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc2099-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fced3d-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc22b7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

        --success order - 2 first + fail order - 2 last
            (UUID_TO_BIN('ea694cf0-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea69a8e0-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6956d0-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea69b1e4-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea6b7-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea69604b-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea69cda5-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea831-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea697a86-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea69d6eb-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea6983d3-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea69de9a-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea699e5f-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea69e6ce-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),

    -- for dummy order detail for order for order group
        --order group id: 'a4e3cae1-78cf-11ee-a832-a85e45c41921'
            (UUID_TO_BIN('16fcef85-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc24e6-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcf170-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc2705-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fcf38f-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc2916-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcf5af-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc2afa-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fcf7d6-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc2d1e-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7e0c-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcf9fa-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc2efa-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fcfc2f-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc3118-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fcfe97-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc45fe-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e744a-56dc-11ee-8a50-a85e45c41921')),

        --order group id: '16fdbe9d-8078-11ee-bef9-a85e45c41921'
            (UUID_TO_BIN('16fd00ac-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc4846-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd02a8-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc56ac-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ce1992d4-9d6f-11ee-88e1-02923cab4c75'), 1, UUID_TO_BIN('ce1994f1-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ce1993ea-9d6f-11ee-88e1-02923cab4c75'), 1, UUID_TO_BIN('ce1995f8-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

        --order group id: 'a4e3cdbb-78cf-11ee-a832-a85e45c41921'
            (UUID_TO_BIN('16fd0488-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc59c9-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eaf69-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd0745-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc5bd1-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eb268-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fd0979-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc5e53-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4897-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd0ba1-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc607d-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fd0e0f-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc62ab-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eb268-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd1003-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc64aa-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e744a-56dc-11ee-8a50-a85e45c41921')),

        --order group id: '16fd4f45-8078-11ee-bef9-a85e45c41921' (first two block is new processing order)
            (UUID_TO_BIN('ea6c4c22-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6cb6e1-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4cbe-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6c3f3e-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6c8929-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4fce-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea6c319a-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6c77ba-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e49f8-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6c24b8-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6c5897-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e8083-56dc-11ee-8a50-a85e45c41921')),


            (UUID_TO_BIN('16fd120d-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc66db-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea831-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd1438-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc68c9-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fd1699-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc703a-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd18bb-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc72b7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

        --order group id: 'a4e3d067-78cf-11ee-a832-a85e45c41921'
            (UUID_TO_BIN('16fd1b15-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc83c4-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4e60-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd1d6e-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc86c7-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fd1f88-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc88c8-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eab5f-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd21d5-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc8b00-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eb268-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fd23ba-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc8ce2-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd25f4-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc8f24-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fd27d9-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc9161-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd29c4-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc9385-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e7bef-56dc-11ee-8a50-a85e45c41921')),

        --order group id: '16fdbde6-8078-11ee-bef9-a85e45c41921'
            (UUID_TO_BIN('16fd2c74-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc9608-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd2e5e-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc9918-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ce198cb6-9d6f-11ee-88e1-02923cab4c75'), 1, UUID_TO_BIN('ce198ec9-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ce198dbe-9d6f-11ee-88e1-02923cab4c75'), 1, UUID_TO_BIN('ce198fc8-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

        --order group id: 'a4e3d18e-78cf-11ee-a832-a85e45c41921'
            (UUID_TO_BIN('16fd309e-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc9bcc-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea831-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd328d-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fc9e06-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4897-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fd34e6-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fca04c-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e744a-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd3733-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fca2d9-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

        --order group id: '16fdbd2c-8078-11ee-bef9-a85e45c41921'
            (UUID_TO_BIN('16fd3976-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fca9de-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd3c69-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fcac00-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ce19473e-9d6f-11ee-88e1-02923cab4c75'), 1, UUID_TO_BIN('ce19887b-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('ec5ea9a5-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ce1986ae-9d6f-11ee-88e1-02923cab4c75'), 1, UUID_TO_BIN('ce19899d-9d6f-11ee-88e1-02923cab4c75'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

        --order group id: '16fd4d4b-8078-11ee-bef9-a85e45c41921' (first two block is new processing order)
            (UUID_TO_BIN('ea6ba0b4-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6bd3be-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6b8432-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6bc4f3-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4cbe-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea6b7352-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6bb921-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4627-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6b51a3-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6bac87-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eaf69-56dc-11ee-8a50-a85e45c41921')),


            (UUID_TO_BIN('16fd3e60-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fcae1a-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5ea50d-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd408a-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fcb02f-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4e60-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('16fd4275-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fcb297-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e4e60-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('16fd44b4-8078-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('16fcb4bb-8078-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e44d1-56dc-11ee-8a50-a85e45c41921')),

        --order group id: 'ea6a14b1-89ad-11ee-bef9-a85e45c41921' (success 2 first - fail 2 last)
            (UUID_TO_BIN('ea6a2f0c-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6a9321-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e8385-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6a39a1-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6aa019-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e49f8-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea6a54e9-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6aaca4-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eacbb-56dc-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('ea6a6224-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6accd3-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5e869e-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea6a81d7-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6ae1b7-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921')),

            (UUID_TO_BIN('ea6a8ca0-89ad-11ee-bef9-a85e45c41921'), 1, UUID_TO_BIN('ea6afe79-89ad-11ee-bef9-a85e45c41921'), UUID_TO_BIN('ec5eae10-56dc-11ee-8a50-a85e45c41921'));


INSERT INTO `saving_hour_market`.`feed_back` (`id`, `message`, `response_message`, `rate`, `object`, `created_time`, `status`, `customer_id`, `order_id`)
    VALUES (UUID_TO_BIN('ea7248cb-89ad-11ee-bef9-a85e45c41921'), 'Dịch vụ tốt, sản phẩm rẻ', null, 5, 'ORDER', '2023-10-20 09:00:00', @processingFeeback, UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf7b01-5541-11ee-8a50-a85e45c41921')),
           (UUID_TO_BIN('ea7249ad-89ad-11ee-bef9-a85e45c41921'), 'Háng hóa được đóng gói cẩn thận. Đánh giá 5 sao', null, 5, 'ORDER', '2023-10-18 09:00:00', @processingFeeback, UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf7c79-5541-11ee-8a50-a85e45c41921')),
           (UUID_TO_BIN('ea724af4-89ad-11ee-bef9-a85e45c41921'), 'Nhân viên giao hàng đúng giờ. Đánh giá 5 sao', null, 5, 'ORDER', '2023-10-18 09:00:00', @processingFeeback, UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf7dc4-5541-11ee-8a50-a85e45c41921')),
           (UUID_TO_BIN('ea724c42-89ad-11ee-bef9-a85e45c41921'), 'Sản phẩm tốt, rẻ', null, 5, 'ORDER', '2023-11-20 09:00:00', @processingFeeback, UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('ea6b0aec-89ad-11ee-bef9-a85e45c41921'));

INSERT INTO `saving_hour_market`.`transaction` (`id`, `payment_method`, `payment_time`, `amount_of_money`, `transaction_no`, `order_id`, `refund_id`)
--   VALUES  (`id`, `payment_method`, `payment_time`, `amount_of_money`, `transaction_no`, `order_id`, `refund_id`)
    VALUES  (UUID_TO_BIN('16fdb03d-8078-11ee-bef9-a85e45c41921'), @vnpay, '2023-11-18 13:00:00', '320000', '11111111111111', UUID_TO_BIN('a4e3c710-78cf-11ee-a832-a85e45c41921'), null),


--             (UUID_TO_BIN('16fda6c8-8078-11ee-bef9-a85e45c41921'), @vnpay, '2023-09-15 13:00:00', '546000', null, null, null),
            (UUID_TO_BIN('16fda601-8078-11ee-bef9-a85e45c41921'), @vnpay, '2023-10-14 13:00:00', '263000', '12345567890000', UUID_TO_BIN('accf7dc4-5541-11ee-8a50-a85e45c41921'), null),
            (UUID_TO_BIN('16fdbf53-8078-11ee-bef9-a85e45c41921'), @vnpay, @orderCreateDateBatchingForGroup, '107000', '12356789111111', UUID_TO_BIN('a4e3bc3a-78cf-11ee-a832-a85e45c41921'), null),
            (UUID_TO_BIN('16fdc00c-8078-11ee-bef9-a85e45c41921'), @vnpay, @orderCreateDateBatchingForGroup, '83000', '12356789222222', UUID_TO_BIN('a4e3bd5d-78cf-11ee-a832-a85e45c41921'), null),
            (UUID_TO_BIN('16fdc0cc-8078-11ee-bef9-a85e45c41921'), @vnpay, @orderCreateDateBatchingForGroup, '251000', '12356789333333', UUID_TO_BIN('a4e3be96-78cf-11ee-a832-a85e45c41921'), null),

            -- transaction need to refund
            (UUID_TO_BIN('ea72538f-89ad-11ee-bef9-a85e45c41921'), @vnpay, @orderCreateDateForOrderCancel, '60000', '12356789444444', UUID_TO_BIN('ea725183-89ad-11ee-bef9-a85e45c41921'), null),
            (UUID_TO_BIN('ea72545d-89ad-11ee-bef9-a85e45c41921'), @vnpay, @orderCreateDateForOrderCancel, '60000', '12356789555555', UUID_TO_BIN('ea725256-89ad-11ee-bef9-a85e45c41921'), null);









-- UUID gen







-- 'ce19990d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce199aa1-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19a037-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19b446-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19b86d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19b9b7-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19bc12-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19bd40-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19be4b-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19bf5e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19c07c-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19c430-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19c566-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19c676-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19c782-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19c888-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19cb90-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19ccb9-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19ce38-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19cf4a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19d04a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19d28a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19d39f-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19d4a8-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19f645-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19f895-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19f9ca-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19fad4-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19fbf1-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19fd01-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19fe0c-9d6f-11ee-88e1-02923cab4c75'
-- 'ce19ff16-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0021-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0127-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a022d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0338-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a043e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0547-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a064e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a074e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0847-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0953-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0b4e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0c4a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0d44-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0e3d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a0f36-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1035-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1131-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a122c-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a145e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a157f-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1677-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a178e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a188d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1992-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1a8b-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1ba2-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1ca6-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1db4-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1eb6-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a1fb7-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a206f-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2129-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a21de-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2308-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a23c1-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2474-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a25f2-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a26c4-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2779-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2878-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a292d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2a04-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2ab9-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2b6a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2c1a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2ccb-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2d7a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2e29-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2edc-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a2f8c-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3045-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a30f5-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a31a3-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3255-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a330d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a33bf-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a346c-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3596-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a364a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a36fb-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a37af-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3868-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a391d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a39d8-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3a90-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3b4c-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3c16-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3cd6-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3d8d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3e47-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3f0a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a3ff1-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a40ad-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a416f-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4233-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a42ea-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a439e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a445d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4545-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a45c4-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4635-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a46a9-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4789-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4887-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4900-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4982-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a49f2-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4a5f-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4ace-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4b42-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4bb2-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4c20-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4c8e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4d00-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4d70-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4ddf-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4e4d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4ebc-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4f2b-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a4f99-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a500a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5078-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a50ea-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a515b-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a51c7-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5237-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a52a8-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5314-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5381-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a53f0-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a545f-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5562-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a55d3-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a563e-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a56ae-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a571f-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a578a-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a57fb-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5865-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a58d1-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a593b-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a59a9-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5a18-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5a83-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5aee-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5b59-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5bc4-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5c32-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5cb9-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5d28-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5d99-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a5e05-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6132-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a61f9-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a627d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a66ea-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6784-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a67fa-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a686c-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a68d9-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6a15-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6a89-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6af8-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6b68-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6bd8-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6c4d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6cc0-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6d32-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6d9d-9d6f-11ee-88e1-02923cab4c75'
-- 'ce1a6e0c-9d6f-11ee-88e1-02923cab4c75'






















