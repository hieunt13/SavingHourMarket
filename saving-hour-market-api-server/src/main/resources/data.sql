-- Satus: enable(1), disable(0)
SET @enable = 1;
SET @disable = 0;
-- Gender: Female(1), Male(0)
SET @female = 1;
SET @male = 0;

-- Product description
SET @OmoDescription = 'Nước Giặt Omo Matic với công nghệ Màn chắn Kháng bẩn Polyshield Xanh, giúp bao bọc và phủ một lớp màn chắn vô hình lên bề mặt sợi vải, loại bỏ nhanh chóng vết bẩn cứng đầu và mùi hôi trên áo quần.
\nBền Màu sau 100 lần giặt
\nChuyên dụng cho máy giặt cửa trước
\n11 Hãng máy giặt hàng đầu tin dùng như AQUA, LG, Panasonic
\nThân thiện môi trường với hoạt chất phân huỷ sinh học
\nOMO tự hào cùng các bé lấm bẩn trồng cây, kiến tạo thêm nhiều màn chắn xanh cho Việt Nam';

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



-- Customer TABLE
INSERT INTO `saving_hour_market`.`customer` (`id`, `status`, `date_of_birth`, `address`, `avatar_url`, `email`, `full_name`, `phone`, `gender`)
--     VALUES  ('id', 'status', '# date_of_birth', 'address', 'avatar_url', 'email', 'full_name', 'password', 'phone', 'username'),
    VALUES  (UUID_TO_BIN('accef2db-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh', 'https://picsum.photos/200/300', 'luugiavinh0@gmail.com', 'Luu Gia Vinh', '0902828618', @male),
            (UUID_TO_BIN('accef4cc-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '50 Lê Văn Việt, Hiệp Phú, Quận 9, Thành phố Hồ Chí Minh', 'https://picsum.photos/200/300', 'ladieuvan457@gmail.com', 'La Dieu Van', '0961780569', @female),
            (UUID_TO_BIN('accef619-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '81 Nguyễn Xiển, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh', 'https://picsum.photos/200/300', 'chuonghoaiviet555@gmail.com', 'Chuong Hoai Viet', '0904757264', @male),
            (UUID_TO_BIN('accef73d-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '740 Nguyễn Xiển, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh', 'https://picsum.photos/200/300', 'donganthu977@gmail.com', 'Dong An Thu', '0903829475', @female),
            (UUID_TO_BIN('accef866-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '269 Đ. Liên Phường, Phước Long B, Quận 9, Thành phố Hồ Chí Minh', 'https://picsum.photos/200/300', 'ngachongquang185@gmail.com', 'Ngac Hong Quang', '0904659243', @male),
            (UUID_TO_BIN('accef988-5541-11ee-8a50-a85e45c41921'), @enable, '2002-05-05', '441 Lê Văn Việt, Tăng Nhơn Phú A, Quận 9, Thành phố Hồ Chí Minh', 'https://picsum.photos/200/300', 'ungthanhgiang458@gmail.com', 'Ung Thanh Giang', '0905628465', @female);


-- Product category
INSERT INTO `saving_hour_market`.`product_category` (`id`, `allowable_display_threshold`, `name`)
--     VALUES  ('# allowable_display_threshold', ?, 'name');
    VALUES  (UUID_TO_BIN('accefaab-5541-11ee-8a50-a85e45c41921'), 3, 'Drink'),
            (UUID_TO_BIN('accefbca-5541-11ee-8a50-a85e45c41921'), 2, 'Food'),
            (UUID_TO_BIN('accefcee-5541-11ee-8a50-a85e45c41921'), 5, 'Spice'),
            (UUID_TO_BIN('accefe0d-5541-11ee-8a50-a85e45c41921'), 10, 'Cosmetic'),
            (UUID_TO_BIN('acceff37-5541-11ee-8a50-a85e45c41921'), 5, 'Pet Food'),
            (UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921'), 15, 'Cleaning Supply');


-- Supermarket
INSERT INTO `saving_hour_market`.`supermarket` (`id`, `status`, `address`, `name`, `phone`)
--     VALUES ('id', 'status', 'address', 'name', 'phone');
    VALUES  (UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921'), @enable, '34 Đ. Nam Cao, Phường Tân Phú, Quận 9, Thành phố Hồ Chí Minh', 'Vinmart+', '0904756354'),
            (UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921'), @enable, '191 Quang Trung, Hiệp Phú, Quận 9, Thành phố Hồ Chí Minh', 'Co.opmart', '0904736452'),
--             (UUID_TO_BIN('accf028b-5541-11ee-8a50-a85e45c41921'), @enable, '167 Đỗ Xuân Hợp, Phước Long B, Quận 9, Thành phố Hồ Chí Minh', 'Europamart', '0904628495'),
            (UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921'), @enable, '46 Đ.61, Phước Long B, Quận 9, Thành phố Hồ Chí Minh', 'Bách hóa xanh', '0903636253'),
            (UUID_TO_BIN('accf0709-5541-11ee-8a50-a85e45c41921'), @enable, '344 Lê Văn Việt, Tăng Nhơn Phú B, Quận 9, Thành phố Hồ Chí Minh', 'Vissan', '0905736451');


-- Time frame
INSERT INTO `saving_hour_market`.`time_frame` (`id`, `day_of_week`, `from_hour`, `to_hour`, `status`)
--     VALUES ('id', 'day_of_week', 'from_hour', 'to_hour', 'status');
    VALUES  (UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), 0, '19:00:00', '20:30:00', @enable),
            (UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), 0, '21:00:00', '22:30:00', @enable);


-- Pickup point
INSERT INTO `saving_hour_market`.`pickup_point` (`id`, `address`, `latitude`, `longitude`, `status`)
--     VALUES ('id', 'address', 'latitude', 'longitude', 'status');
    VALUES  (UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921'), '662/2 Nguyễn Văn Tăng, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh', 10.844867, 106.831038, @enable),
            (UUID_TO_BIN('accf0be1-5541-11ee-8a50-a85e45c41921'), '63 Đ. Võ Nguyên Giáp, Thảo Điền, Quận 2, Thành phố Hồ Chí Minh', 10.801419, 106.736042, @enable),
            (UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921'), '432 Đ. Liên Phường, Phước Long B, Quận 9, Thành phố Hồ Chí Minh', 10.805475, 106.789022, @enable),
            (UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921'), '857 Phạm Văn Đồng, P, Thủ Đức, Thành phố Hồ Chí Minh', 10.852884, 106.750717, @enable),
            (UUID_TO_BIN('accf0f40-5541-11ee-8a50-a85e45c41921'), '528 Huỳnh Tấn Phát, Tân Thuận Đông, Quận 7, Thành phố Hồ Chí Minh', 10.738769, 106.729944, @enable),
            (UUID_TO_BIN('accf105d-5541-11ee-8a50-a85e45c41921'), '159 Đ. Võ Nguyên Giáp, Thảo Điền, Quận 2, Thành phố Hồ Chí Minh', 10.803325, 106.741962, @enable),
            (UUID_TO_BIN('accf117b-5541-11ee-8a50-a85e45c41921'), '96 Đường số 4, Phước Bình, Quận 9, Thành phố Hồ Chí Minh', 10.818573, 106.771057, @enable);


-- Order Group
INSERT INTO `saving_hour_market`.`order_group` (`id`, `time_frame_id`, `pickup_point_id`)
--     VALUES ('id', 'time_frame_id', 'pickup_point_id');
    VALUES  (UUID_TO_BIN('accf129e-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf13f0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0be1-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf15b0-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf1749-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf187a-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0f40-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf19db-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf105d-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf1baa-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0876-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf117b-5541-11ee-8a50-a85e45c41921')),
--          second time frame
            (UUID_TO_BIN('accf1f39-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0ac0-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf20d1-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0be1-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf2205-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0d06-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf2391-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0e1e-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf26cb-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0f40-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf2846-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf105d-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf29d6-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0996-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf117b-5541-11ee-8a50-a85e45c41921'));


-- Product
INSERT INTO `saving_hour_market`.`product` (`id`, `name`, `price`, `price_original`, `quantity`, `expired_date`, `description`, `image_url`, `status`, `product_category_id`, `supermarket_id`)
--     VALUES (`id`, `name`, `price`, `price_original`, `quantity`, `expired_date`, `description`, `image_url`, `status`, `product_category_id`, `supermarket_id`);
    VALUES  (UUID_TO_BIN('accf2b04-5541-11ee-8a50-a85e45c41921'), 'Nước giặt Omo 2,9kg', 159000, 200000, 50, '2023-11-25 00:00:00', @OmoDescription, 'https://picsum.photos/500/500', @enable, UUID_TO_BIN('accf0055-5541-11ee-8a50-a85e45c41921'), UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf2c1d-5541-11ee-8a50-a85e45c41921'), 'Chả Giò Tôm Cua 500g', 55000, 85000, 15, '2023-10-10 00:00:00', @ChaGioTomCuaDescription, 'https://picsum.photos/500/500', @enable, null, UUID_TO_BIN('accf0709-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf2d37-5541-11ee-8a50-a85e45c41921'), 'Giò Heo Xông Khói 500g', 90000, 135000, 10, '2023-10-05 00:00:00', @GioHeoXongKhoi, 'https://picsum.photos/500/500', @enable, null, UUID_TO_BIN('accf0709-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf2f65-5541-11ee-8a50-a85e45c41921'), 'Kem Wall’s Oreo hộp 750ml', 75000, 100000, 25, '2023-10-01 00:00:00', @KemWallOreo, 'https://picsum.photos/500/500', @enable, null, UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3079-5541-11ee-8a50-a85e45c41921'), 'Bột Milo Protomalt hũ 400g', 60000, 80000, 30, '2023-10-15 00:00:00', @BotMilo, 'https://picsum.photos/500/500', @enable, null, UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf32f7-5541-11ee-8a50-a85e45c41921'), 'Nho mẫu đơn nội địa Trung 500g', 51000, 75000, 10, '2023-09-28 00:00:00', @NhoMauDon, 'https://picsum.photos/500/500', @enable, null, UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf343c-5541-11ee-8a50-a85e45c41921'), '2 lốc sữa chua Vinamilk nha đam (8 hộp)', 42000, 60000, 10, '2023-09-30 00:00:00', @SuaChuaVinamilk, 'https://picsum.photos/500/500', @enable, null, UUID_TO_BIN('accf04c8-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3552-5541-11ee-8a50-a85e45c41921'), '1 lốc hộp sữa tươi Vinamilk có đường (4 hộp)', 25000, 33000, 15, '2023-10-03 00:00:00', @SuaTuoiVinamilk, 'https://picsum.photos/500/500', @enable, null, UUID_TO_BIN('accf0172-5541-11ee-8a50-a85e45c41921')),
            (UUID_TO_BIN('accf3664-5541-11ee-8a50-a85e45c41921'), 'Sữa tắm Lifebuoy Vitamin 800g', 145000, 180000, 10, '2023-11-20 00:00:00', @SuaTamLifeBoy, 'https://picsum.photos/500/500', @enable, null, UUID_TO_BIN('accf03a7-5541-11ee-8a50-a85e45c41921'));
--             (UUID_TO_BIN('accf377f-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf3897-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf39b0-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf3ac4-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf3be3-5541-11ee-8a50-a85e45c41921')),
--             (UUID_TO_BIN('accf3cf4-5541-11ee-8a50-a85e45c41921')),



-- UUID gen
-- 'accf3fdf-5541-11ee-8a50-a85e45c41921'
-- 'accf40fe-5541-11ee-8a50-a85e45c41921'
-- 'accf4210-5541-11ee-8a50-a85e45c41921'
-- 'accf4320-5541-11ee-8a50-a85e45c41921'
-- 'accf442f-5541-11ee-8a50-a85e45c41921'
-- 'accf4547-5541-11ee-8a50-a85e45c41921'
-- 'accf4656-5541-11ee-8a50-a85e45c41921'
-- 'accf4766-5541-11ee-8a50-a85e45c41921'
-- 'accf4875-5541-11ee-8a50-a85e45c41921'
-- 'accf4991-5541-11ee-8a50-a85e45c41921'
-- 'accf4aa8-5541-11ee-8a50-a85e45c41921'
-- 'accf4c03-5541-11ee-8a50-a85e45c41921'
-- 'accf4d19-5541-11ee-8a50-a85e45c41921'
-- 'accf4e43-5541-11ee-8a50-a85e45c41921'
-- 'accf4f95-5541-11ee-8a50-a85e45c41921'
-- 'accf50b8-5541-11ee-8a50-a85e45c41921'
-- 'accf51d6-5541-11ee-8a50-a85e45c41921'
-- 'accf52f8-5541-11ee-8a50-a85e45c41921'
-- 'accf5414-5541-11ee-8a50-a85e45c41921'
-- 'accf6fdd-5541-11ee-8a50-a85e45c41921'
-- 'accf7135-5541-11ee-8a50-a85e45c41921'
-- 'accf726f-5541-11ee-8a50-a85e45c41921'
-- 'accf7392-5541-11ee-8a50-a85e45c41921'
-- 'accf7525-5541-11ee-8a50-a85e45c41921'
-- 'accf765b-5541-11ee-8a50-a85e45c41921'
-- 'accf77a1-5541-11ee-8a50-a85e45c41921'
-- 'accf78c1-5541-11ee-8a50-a85e45c41921'
-- 'accf79e1-5541-11ee-8a50-a85e45c41921'
-- 'accf7b01-5541-11ee-8a50-a85e45c41921'
-- 'accf7c79-5541-11ee-8a50-a85e45c41921'
-- 'accf7dc4-5541-11ee-8a50-a85e45c41921'
-- 'accf7ee5-5541-11ee-8a50-a85e45c41921'
-- 'accf8026-5541-11ee-8a50-a85e45c41921'
-- 'accf814e-5541-11ee-8a50-a85e45c41921'
-- 'accf8271-5541-11ee-8a50-a85e45c41921'
-- 'accf8390-5541-11ee-8a50-a85e45c41921'
-- 'accf84af-5541-11ee-8a50-a85e45c41921'
-- 'accf864a-5541-11ee-8a50-a85e45c41921'
-- 'accf8775-5541-11ee-8a50-a85e45c41921'
-- 'accf88e1-5541-11ee-8a50-a85e45c41921'
--