/* eslint-disable react-native/no-inline-styles */
/* eslint-disable prettier/prettier */

import {
  View,
  Text,
  TouchableOpacity,
  TouchableWithoutFeedback,
  Keyboard,
  StyleSheet,
  Image,
  TextInput,
  ScrollView,
  Modal,
  Pressable,
  Alert,
  FlatList,
} from 'react-native';
import React, {useEffect, useState, useCallback, useRef} from 'react';
import auth from '@react-native-firebase/auth';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {COLORS} from '../../constants/theme';
import {icons} from '../../constants';
import {useFocusEffect} from '@react-navigation/native';
import {API} from '../../constants/api';
import {format} from 'date-fns';
import CartEmpty from '../../assets/image/search-empty.png';
import {SwipeListView} from 'react-native-swipe-list-view';
import LoadingScreen from '../../components/LoadingScreen';
import {da} from 'date-fns/locale';
import DatePicker from 'react-native-date-picker';
import {
  ModalButton,
  ModalContent,
  ModalFooter,
  ScaleAnimation,
} from 'react-native-modals';

const OrderGroupForOrderStaff = ({navigation, route}) => {
  const [initializing, setInitializing] = useState(true);
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [currentStatus, setCurrentStatus] = useState({
    display: 'Chờ đóng gói',
    value: 'PROCESSING',
  });
  const [visible, setVisible] = useState(false);
  const [pickupPoint, setPickupPoint] = useState(null);
  const [currentUser, setCurrentUser] = useState(null);

  const orderGroupAreaState = [
    {display: 'Chờ đóng gói', value: 'PROCESSING'},
    {display: 'Đang đóng gói', value: 'PACKAGING'},
    {display: 'Đã đóng gói', value: 'PACKAGED'},
  ];

  // init fake timeframe
  const [timeFrameList, setTimeFrameList] = useState([
    {
      id: 'accf0876-5541-11ee-8a50-a85e45c41921',
      fromHour: '19:00:00',
      toHour: '20:30:00',
      status: 1,
      allowableDeliverMethod: 0,
    },
    {
      id: 'accf0996-5541-11ee-8a50-a85e45c41921',
      fromHour: '21:00:00',
      toHour: '22:30:00',
      status: 1,
      allowableDeliverMethod: 0,
    },
  ]);

  // init area fake data
  const [consolidationAreaList, setConsolidationAreaList] = useState([
    {
      id: 'ec5dfa4a-56dc-11ee-8a50-a85e45c41921',
      address: 'Đường N7, Tăng Nhơn Phú A, Thủ Đức, Hồ Chí Minh',
      status: 1,
      longitude: 106.80459035612381,
      latitude: 10.846756594531838,
      pickupPointList: [
        {
          id: 'accf0ac0-5541-11ee-8a50-a85e45c41921',
          address: 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh',
          status: 1,
          longitude: 106.83102962168277,
          latitude: 10.845020092805793,
        },
        {
          id: 'accf0d06-5541-11ee-8a50-a85e45c41921',
          address: '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh',
          status: 1,
          longitude: 106.7891284,
          latitude: 10.8059505,
        },
      ],
    },
    {
      id: 'ec5dfde4-56dc-11ee-8a50-a85e45c41921',
      address: '9 Nam Hòa, Phước Long A, Thủ Đức, Hồ Chí Minh',
      status: 1,
      longitude: 106.76009552300007,
      latitude: 10.821593957000061,
      pickupPointList: [
        {
          id: 'accf0e1e-5541-11ee-8a50-a85e45c41921',
          address: '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh',
          status: 1,
          longitude: 106.75072682500007,
          latitude: 10.85273099400007,
        },
        {
          id: 'accf105d-5541-11ee-8a50-a85e45c41921',
          address: '77C Trần Ngọc Diện, Thảo Điền, Thủ Đức, Hồ Chí Minh',
          status: 1,
          longitude: 106.73845902300008,
          latitude: 10.80274197700004,
        },
      ],
    },
    {
      id: 'ec5dfde4-56dc-11ee-8a50-a85e45c41927',
      address: '9 Nam Hòa, Phước Long A, Thủ Đức, Hồ Chí Minh',
      status: 1,
      longitude: 106.76009552300007,
      latitude: 10.821593957000061,
      pickupPointList: [
        {
          id: 'accf0e1e-5541-11ee-8a50-a85e45c41921',
          address: '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh',
          status: 1,
          longitude: 106.75072682500007,
          latitude: 10.85273099400007,
        },
        {
          id: 'accf105d-5541-11ee-8a50-a85e45c41921',
          address: '77C Trần Ngọc Diện, Thảo Điền, Thủ Đức, Hồ Chí Minh',
          status: 1,
          longitude: 106.73845902300008,
          latitude: 10.80274197700004,
        },
      ],
    },
    {
      id: 'ec5dfde4-56dc-11ee-8a50-a85e45c41926',
      address: '9 Nam Hòa, Phước Long A, Thủ Đức, Hồ Chí Minh',
      status: 1,
      longitude: 106.76009552300007,
      latitude: 10.821593957000061,
      pickupPointList: [
        {
          id: 'accf0e1e-5541-11ee-8a50-a85e45c41921',
          address: '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh',
          status: 1,
          longitude: 106.75072682500007,
          latitude: 10.85273099400007,
        },
        {
          id: 'accf105d-5541-11ee-8a50-a85e45c41921',
          address: '77C Trần Ngọc Diện, Thảo Điền, Thủ Đức, Hồ Chí Minh',
          status: 1,
          longitude: 106.73845902300008,
          latitude: 10.80274197700004,
        },
      ],
    },
  ]);

  // init fake order group data
  const [orderGroupList, setOrderGroupList] = useState([
    {
      id: 'accf19db-5541-11ee-8a50-a85e45c41922',
      isExpand: true,
      deliverDate: '2023-09-19',
      timeFrame: {
        id: 'accf0876-5541-11ee-8a50-a85e45c41921',
        fromHour: '19:00:00',
        toHour: '20:30:00',
        status: 1,
        allowableDeliverMethod: 0,
      },
      pickupPoint: {
        id: 'accf105d-5541-11ee-8a50-a85e45c41921',
        address: '77C Trần Ngọc Diện, Thảo Điền, Thủ Đức, Hồ Chí Minh',
        status: 1,
        longitude: 106.73845902300008,
        latitude: 10.80274197700004,
      },
      deliverer: null,
      orderList: [
        {
          id: 'ec5de351-56dc-11ee-8a50-a85e45c41921',
          shippingFee: 0,
          totalPrice: 216000,
          receiverPhone: null,
          receiverName: null,
          longitude: null,
          latitude: null,
          totalDiscountPrice: 0,
          createdTime: '2023-11-18T08:00:00',
          deliveryDate: '2023-11-17',
          qrCodeUrl: 'qr code url here',
          status: 1,
          paymentMethod: 1,
          deliveryMethod: 0,
          addressDeliver: null,
          paymentStatus: 1,
          packager: {
            id: 'accf4d19-5541-11ee-8a50-a85e45c41921',
            fullName: 'Hong Quang',
            email: 'quangphse161539@fpt.edu.vn',
            avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media',
            role: 'STAFF_ORD',
            status: 1,
            pickupPoint: [
              {
                id: 'accf0ac0-5541-11ee-8a50-a85e45c41921',
                address:
                  'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh',
                status: 1,
                longitude: 106.83102962168277,
                latitude: 10.845020092805793,
              },
              {
                id: 'accf0d06-5541-11ee-8a50-a85e45c41921',
                address:
                  '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh',
                status: 1,
                longitude: 106.7891284,
                latitude: 10.8059505,
              },
            ],
          },
          deliverer: null,
          customer: {
            id: 'accef2db-5541-11ee-8a50-a85e45c41923',
            fullName: 'Luu Gia Vinh',
            email: 'luugiavinh0@gmail.com',
            phone: '0902828618',
            dateOfBirth: '2002-05-05',
            avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media',
            address:
              '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh',
            gender: 0,
            status: 1,
          },
          timeFrame: null,
          pickupPoint: null,
          discountList: [],
          transaction: [],
          productConsolidationArea: null,
        },
      ],
      productConsolidationArea: null,
    },
    {
      id: 'accf19db-5541-11ee-8a50-a85e45c41925',
      isExpand: true,
      deliverDate: '2023-09-19',
      timeFrame: {
        id: 'accf0876-5541-11ee-8a50-a85e45c41921',
        fromHour: '19:00:00',
        toHour: '20:30:00',
        status: 1,
        allowableDeliverMethod: 0,
      },
      pickupPoint: {
        id: 'accf105d-5541-11ee-8a50-a85e45c41921',
        address: '77C Trần Ngọc Diện, Thảo Điền, Thủ Đức, Hồ Chí Minh',
        status: 1,
        longitude: 106.73845902300008,
        latitude: 10.80274197700004,
      },
      deliverer: null,
      orderList: [
        {
          id: 'ec5de351-56dc-11ee-8a50-a85e45c41921',
          shippingFee: 0,
          totalPrice: 216000,
          receiverPhone: null,
          receiverName: null,
          longitude: null,
          latitude: null,
          totalDiscountPrice: 0,
          createdTime: '2023-11-18T08:00:00',
          deliveryDate: '2023-11-17',
          qrCodeUrl: 'qr code url here',
          status: 1,
          paymentMethod: 1,
          deliveryMethod: 0,
          addressDeliver: null,
          paymentStatus: 1,
          packager: {
            id: 'accf4d19-5541-11ee-8a50-a85e45c41921',
            fullName: 'Hong Quang',
            email: 'quangphse161539@fpt.edu.vn',
            avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media',
            role: 'STAFF_ORD',
            status: 1,
            pickupPoint: [
              {
                id: 'accf0ac0-5541-11ee-8a50-a85e45c41921',
                address:
                  'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh',
                status: 1,
                longitude: 106.83102962168277,
                latitude: 10.845020092805793,
              },
              {
                id: 'accf0d06-5541-11ee-8a50-a85e45c41921',
                address:
                  '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh',
                status: 1,
                longitude: 106.7891284,
                latitude: 10.8059505,
              },
            ],
          },
          deliverer: null,
          customer: {
            id: 'accef2db-5541-11ee-8a50-a85e45c41921',
            fullName: 'Luu Gia Vinh',
            email: 'luugiavinh0@gmail.com',
            phone: '0902828618',
            dateOfBirth: '2002-05-05',
            avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media',
            address:
              '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh',
            gender: 0,
            status: 1,
          },
          timeFrame: null,
          pickupPoint: null,
          discountList: [],
          transaction: [],
          productConsolidationArea: null,
        },
      ],
      productConsolidationArea: {
        id: 'ec5dfde4-56dc-11ee-8a50-a85e45c41921',
        address: '9 Nam Hòa, Phước Long A, Thủ Đức, Hồ Chí Minh',
        status: 1,
        longitude: 106.76009552300007,
        latitude: 10.821593957000061,
        pickupPointList: [
          {
            id: 'accf0e1e-5541-11ee-8a50-a85e45c41921',
            address: '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh',
            status: 1,
            longitude: 106.75072682500007,
            latitude: 10.85273099400007,
          },
          {
            id: 'accf105d-5541-11ee-8a50-a85e45c41921',
            address: '77C Trần Ngọc Diện, Thảo Điền, Thủ Đức, Hồ Chí Minh',
            status: 1,
            longitude: 106.73845902300008,
            latitude: 10.80274197700004,
          },
        ],
      },
    },
    {
      id: 'accf19db-5541-11ee-8a50-a85e45c41921',
      isExpand: true,
      deliverDate: '2023-09-19',
      timeFrame: {
        id: 'accf0876-5541-11ee-8a50-a85e45c41921',
        fromHour: '19:00:00',
        toHour: '20:30:00',
        status: 1,
        allowableDeliverMethod: 0,
      },
      pickupPoint: {
        id: 'accf105d-5541-11ee-8a50-a85e45c41921',
        address: '77C Trần Ngọc Diện, Thảo Điền, Thủ Đức, Hồ Chí Minh',
        status: 1,
        longitude: 106.73845902300008,
        latitude: 10.80274197700004,
      },
      deliverer: null,
      orderList: [
        {
          id: 'ec5de351-56dc-11ee-8a50-a85e45c41921',
          shippingFee: 0,
          totalPrice: 216000,
          receiverPhone: null,
          receiverName: null,
          longitude: null,
          latitude: null,
          totalDiscountPrice: 0,
          createdTime: '2023-11-18T08:00:00',
          deliveryDate: '2023-11-17',
          qrCodeUrl: 'qr code url here',
          status: 1,
          paymentMethod: 1,
          deliveryMethod: 0,
          addressDeliver: null,
          paymentStatus: 1,
          packager: {
            id: 'accf4d19-5541-11ee-8a50-a85e45c41921',
            fullName: 'Hong Quang',
            email: 'quangphse161539@fpt.edu.vn',
            avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media',
            role: 'STAFF_ORD',
            status: 1,
            pickupPoint: [
              {
                id: 'accf0ac0-5541-11ee-8a50-a85e45c41921',
                address:
                  'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh',
                status: 1,
                longitude: 106.83102962168277,
                latitude: 10.845020092805793,
              },
              {
                id: 'accf0d06-5541-11ee-8a50-a85e45c41921',
                address:
                  '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh',
                status: 1,
                longitude: 106.7891284,
                latitude: 10.8059505,
              },
            ],
          },
          deliverer: null,
          customer: {
            id: 'accef2db-5541-11ee-8a50-a85e45c41921',
            fullName: 'Luu Gia Vinh',
            email: 'luugiavinh0@gmail.com',
            phone: '0902828618',
            dateOfBirth: '2002-05-05',
            avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media',
            address:
              '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh',
            gender: 0,
            status: 1,
          },
          timeFrame: null,
          pickupPoint: null,
          discountList: [],
          transaction: [],
          productConsolidationArea: null,
        },
        {
          id: 'ec5de351-56dc-11ee-8a50-a85e45c41921',
          shippingFee: 0,
          totalPrice: 216000,
          receiverPhone: null,
          receiverName: null,
          longitude: null,
          latitude: null,
          totalDiscountPrice: 0,
          createdTime: '2023-11-18T08:00:00',
          deliveryDate: '2023-11-17',
          qrCodeUrl: 'qr code url here',
          status: 1,
          paymentMethod: 1,
          deliveryMethod: 0,
          addressDeliver: null,
          paymentStatus: 1,
          packager: {
            id: 'accf4d19-5541-11ee-8a50-a85e45c41921',
            fullName: 'Hong Quang',
            email: 'quangphse161539@fpt.edu.vn',
            avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media',
            role: 'STAFF_ORD',
            status: 1,
            pickupPoint: [
              {
                id: 'accf0ac0-5541-11ee-8a50-a85e45c41921',
                address:
                  'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh',
                status: 1,
                longitude: 106.83102962168277,
                latitude: 10.845020092805793,
              },
              {
                id: 'accf0d06-5541-11ee-8a50-a85e45c41921',
                address:
                  '432 Đ. Liên Phường, Phước Long B, Quận 9, Hồ Chí Minh',
                status: 1,
                longitude: 106.7891284,
                latitude: 10.8059505,
              },
            ],
          },
          deliverer: null,
          customer: {
            id: 'accef2db-5541-11ee-8a50-a85e45c41921',
            fullName: 'Luu Gia Vinh',
            email: 'luugiavinh0@gmail.com',
            phone: '0902828618',
            dateOfBirth: '2002-05-05',
            avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/capstone-project-398104.appspot.com/o/public%2Fdefault-avatar.jpg?alt=media',
            address:
              '240 Phạm Văn Đồng, Hiệp Bình Chánh, Thủ Đức, Thành phố Hồ Chí Minh',
            gender: 0,
            status: 1,
          },
          timeFrame: null,
          pickupPoint: null,
          discountList: [],
          transaction: [],
          productConsolidationArea: null,
        },
      ],
      productConsolidationArea: {
        id: 'ec5dfde4-56dc-11ee-8a50-a85e45c41921',
        address: '9 Nam Hòa, Phước Long A, Thủ Đức, Hồ Chí Minh',
        status: 1,
        longitude: 106.76009552300007,
        latitude: 10.821593957000061,
        pickupPointList: [
          {
            id: 'accf0e1e-5541-11ee-8a50-a85e45c41921',
            address: '857 Phạm Văn Đồng, Linh Tây, Thủ Đức, Hồ Chí Minh',
            status: 1,
            longitude: 106.75072682500007,
            latitude: 10.85273099400007,
          },
          {
            id: 'accf105d-5541-11ee-8a50-a85e45c41921',
            address: '77C Trần Ngọc Diện, Thảo Điền, Thủ Đức, Hồ Chí Minh',
            status: 1,
            longitude: 106.73845902300008,
            latitude: 10.80274197700004,
          },
        ],
      },
    },
  ]);

  const onAuthStateChange = async userInfo => {
    // console.log(userInfo);
    if (initializing) {
      setInitializing(false);
    }
    if (userInfo) {
      // check if user sessions is still available. If yes => redirect to another screen
      const userTokenId = await userInfo
        .getIdToken(true)
        .then(token => token)
        .catch(async e => {
          console.log(e);
          return null;
        });
      if (!userTokenId) {
        // sessions end. (revoke refresh token like password change, disable account, ....)
        await AsyncStorage.removeItem('userInfo');
        navigation.navigate('Login');
        return;
      }
      const currentUser = await AsyncStorage.getItem('userInfo');
      // console.log('currentUser', currentUser);
      setCurrentUser(JSON.parse(currentUser));
    } else {
      // no sessions found.
      console.log('user is not logged in');
      await AsyncStorage.removeItem('userInfo');
      navigation.navigate('Login');
    }
  };

  useFocusEffect(
    useCallback(() => {
      // auth().currentUser.reload()
      const subscriber = auth().onAuthStateChanged(
        async userInfo => await onAuthStateChange(userInfo),
      );

      return subscriber;
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []),
  );

  useFocusEffect(
    useCallback(() => {
      // auth().currentUser.reload()
      const subscriber = auth().onAuthStateChanged(
        async userInfo => await onAuthStateChange(userInfo),
      );

      return subscriber;
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []),
  );

  // intit fetch time frame + order group
  useFocusEffect(
    useCallback(() => {
      console.log('effect run');
      const fetchData = async () => {
        if (auth().currentUser) {
          const tokenId = await auth().currentUser.getIdToken();
          if (tokenId) {
            // setLoading(true);
            // console.log(format(Date.parse(selectedDate), 'yyyy-MM-dd'));
            filterOrderGroup();
            // fetch(
            //   `${API.baseURL}/api/order/packageStaff/getOrderGroup?${
            //     pickupPoint ? 'pickupPointId=' + pickupPoint?.id : ''
            //   }&deliverDate=${format(Date.parse(selectedDate), 'yyyy-MM-dd')}`,
            //   {
            //     method: 'GET',
            //     headers: {
            //       'Content-Type': 'application/json',
            //       Authorization: `Bearer ${tokenId}`,
            //     },
            //   },
            // )
            //   .then(res => res.json())
            //   .then(respond => {
            //     // console.log('order group', respond);
            //     if (respond.error) {
            //       // setLoading(false);
            //       return;
            //     }

            //     setOrderGroupList(respond);
            //     // setLoading(false);
            //   })
            //   .catch(err => {
            //     console.log(err);
            //     // setLoading(false);
            //   });
          }
        }
      };
      // fetch time frame
      fetch(`${API.baseURL}/api/timeframe/getForPickupPoint`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      })
        .then(res => res.json())
        .then(respond => {
          console.log('time frame', respond);
          if (respond.error) {
            // setLoading(false);
            return;
          }

          setTimeFrameList(respond);

          // setLoading(false);
        })
        .catch(err => {
          console.log(err);
          // setLoading(false);
        });
      fetchData();
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [pickupPoint]),
  );

  // response message view modal
  const [openResponseDialog, setOpenResponseDialog] = useState(false);
  const [messageResult, setMessageResult] = useState('');

  // handle sort date
  const [sortModalVisible, setSortModalVisible] = useState(false);
  const sortOptions = [
    {
      id: 1,
      name: 'Ngày giao gần nhất',
      param: '&deliverDateSortType=ASC',
      active: false,
    },
    {
      id: 2,
      name: 'Ngày giao xa nhất',
      param: '&deliverDateSortType=DESC',
      active: false,
    },
  ];

  const [selectSort, setSelectSort] = useState(sortOptions);
  const [tempSelectedSortId, setTempSelectedSortId] = useState('');

  //  filter pickup point
  const [selectedTimeFrameId, setSelectedTimeFrameId] = useState('');
  const [tempSelectedTimeFrameId, setTempSelectedTimeFrameId] = useState('');
  //  filter date
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [tempSelectedDate, setTempSelectedDate] = useState(new Date());

  // filter function
  const filterOrderGroup = async () => {
    const tokenId = await auth().currentUser.getIdToken();
    if (tokenId) {
      // setLoading(true);
      console.log(format(Date.parse(selectedDate), 'yyyy-MM-dd'));
      console.log(format(Date.parse(tempSelectedDate), 'yyyy-MM-dd'));
      console.log(selectedTimeFrameId);
      await fetch(
        `${API.baseURL}/api/order/packageStaff/getOrderGroup?${
          pickupPoint ? 'pickupPointId=' + pickupPoint?.id : ''
        }&deliverDate=${format(Date.parse(selectedDate), 'yyyy-MM-dd')}${
          selectedTimeFrameId === ''
            ? ''
            : '&timeFrameId=' + selectedTimeFrameId
        }${
          tempSelectedSortId === ''
            ? ''
            : selectSort.find(item => item.id === tempSelectedSortId)?.param
        }`,
        {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${tokenId}`,
          },
        },
      )
        .then(res => res.json())
        .then(respond => {
          // console.log('order group', respond);
          if (respond.error) {
            // setLoading(false);
            return;
          }

          setOrderGroupList(respond);
          // setLoading(false);
        })
        .catch(err => {
          console.log(err);
          // setLoading(false);
        });
    }
  };

  // handle apply filter
  const handleApplyFilter = () => {
    setSelectSort(
      selectSort.map(item => {
        if (item.id === tempSelectedSortId) {
          return {...item, active: true};
        }
        return {...item, active: false};
      }),
    );
    setSelectedTimeFrameId(tempSelectedTimeFrameId);
    setSelectedDate(tempSelectedDate);
    setSortModalVisible(!sortModalVisible);
  };

  // fetch data after handle apply filter
  const isMountingRef = useRef(false);

  useEffect(() => {
    isMountingRef.current = true;
  }, []);

  useEffect(() => {
    if (!isMountingRef.current) {
      filterOrderGroup();
    } else {
      isMountingRef.current = false;
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectSort, selectedDate, selectedTimeFrameId]);

  // handle clear sort modal
  const handleClearSortModal = () => {
    // setSelectSort(sortOptions);
    setTempSelectedSortId('');
    setTempSelectedTimeFrameId('');
    setTempSelectedDate(new Date());
    // setSelectedDate(new Date());
    console.log('thiet lap lai');
  };

  // handle close sort modal
  const handleCloseSortModal = () => {
    console.log('close sort modal');
    const activeSortOption = selectSort.find(item => item.active === true);
    setTempSelectedSortId(activeSortOption ? activeSortOption.id : '');
    setTempSelectedDate(selectedDate);
    setTempSelectedTimeFrameId(selectedTimeFrameId);
    setSortModalVisible(!sortModalVisible);
  };

  // handle edit consolidation area model
  const [editAreaModalVisible, setEditAreaModalVisible] = useState(false);
  const [editStatusPackagedModalVisible, setEditStatusPackagedModalVisible] =
    useState(false);
  const [selectedEditGroupId, setSelectedEditGroupId] = useState('');

  const [selectedConsolidationAreaId, setSelectedConsolidationAreaId] =
    useState('');

  // fetch area for group
  const getConsolidationAreaForGroup = async groupPickupPointId => {
    const tokenId = await auth().currentUser.getIdToken();
    if (tokenId) {
      // setLoading(true);
      console.log(format(Date.parse(selectedDate), 'yyyy-MM-dd'));
      await fetch(
        `${API.baseURL}/api/productConsolidationArea/getByPickupPointForStaff?pickupPointId=${groupPickupPointId}`,
        {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${tokenId}`,
          },
        },
      )
        .then(res => res.json())
        .then(respond => {
          // console.log('order group', respond);
          if (respond.error) {
            // setLoading(false);
            return;
          }

          setConsolidationAreaList(respond);
          // setLoading(false);
        })
        .catch(err => {
          console.log(err);
          // setLoading(false);
        });
    }
  };

  // edit consolidation  area function
  const editConsolidationArea = async () => {
    const tokenId = await auth().currentUser.getIdToken();
    if (tokenId) {
      const consolidationAreaEditRequest = await fetch(
        `${API.baseURL}/api/order/packageStaff/confirmPackagingGroup?orderGroupId=${selectedEditGroupId}&productConsolidationAreaId=${selectedConsolidationAreaId}`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${tokenId}`,
          },
        },
      ).catch(err => {
        console.log(err);
        return null;
        // setLoading(false);
      });

      if (!consolidationAreaEditRequest) {
        return;
      }

      if (consolidationAreaEditRequest.status === 200) {
        const result = await consolidationAreaEditRequest.text();
        await filterOrderGroup();
        setMessageResult(result);
        setOpenResponseDialog(true);
      } else {
        const result = await consolidationAreaEditRequest.json();
        console.log(result);
        setMessageResult(result.message);
        setOpenResponseDialog(true);
      }
    }
  };

  // update group status to packaged
  const updateStatusToPackaged = async () => {
    const tokenId = await auth().currentUser.getIdToken();
    if (tokenId) {
      const updateStatusToPackagedRequest = await fetch(
        `${API.baseURL}/api/order/packageStaff/confirmPackagedGroup?orderGroupId=${selectedEditGroupId}`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${tokenId}`,
          },
        },
      ).catch(err => {
        console.log(err);
        return null;
        // setLoading(false);
      });

      if (!updateStatusToPackagedRequest) {
        return;
      }

      if (updateStatusToPackagedRequest.status === 200) {
        const result = await updateStatusToPackagedRequest.text();
        await filterOrderGroup();
        setMessageResult(result);
        setOpenResponseDialog(true);
      } else {
        const result = await updateStatusToPackagedRequest.json();
        console.log(result);
        setMessageResult(result.message);
        setOpenResponseDialog(true);
      }
    }
  };

  const handleOpenEditModal = async (
    groupId,
    isConsolidationAreaNull,
    groupPickupPointId,
  ) => {
    setSelectedEditGroupId(groupId);
    if (isConsolidationAreaNull) {
      // handle add consolidation area
      await getConsolidationAreaForGroup(groupPickupPointId);
      setEditAreaModalVisible(true);
    } else {
      // handle update status for all order in group to packaged
      setEditStatusPackagedModalVisible(true);
    }
  };

  const handleCloseEditModal = groupId => {
    setSelectedEditGroupId('');
    setEditAreaModalVisible(false);
    setEditStatusPackagedModalVisible(false);
    setSelectedConsolidationAreaId('');
  };

  const handleSubmitEditStatusPackaged = async () => {
    await updateStatusToPackaged();
    setEditStatusPackagedModalVisible(false);
    setSelectedEditGroupId('');
    setSelectedConsolidationAreaId('');
  }

  const handleSubmitAreaEditModal = async () => {
    await editConsolidationArea();
    setEditAreaModalVisible(false);
    setSelectedEditGroupId('');
    setSelectedConsolidationAreaId('');
  };

  return (
    <TouchableWithoutFeedback
      onPress={() => {
        Keyboard.dismiss;
        setOpen(false);
      }}
      accessible={false}>
      <View style={styles.container}>
        <View style={styles.header}>
          <View style={styles.areaAndLogout}>
            <View style={styles.area}>
              <Text style={{fontSize: 16}}>Khu vực:</Text>
              <TouchableOpacity
                onPress={() => {
                  navigation.navigate('SelectPickupPoint', {
                    setPickupPoint: setPickupPoint,
                    isFromOrderGroupRoute: true,
                  });
                }}>
                <View style={styles.pickArea}>
                  <View style={styles.pickAreaItem}>
                    <Image
                      resizeMode="contain"
                      style={{width: 20, height: 20, tintColor: COLORS.primary}}
                      source={icons.location}
                    />
                    <Text
                      style={{
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: 'black',
                      }}>
                      {pickupPoint
                        ? pickupPoint.address
                        : 'Chọn điểm giao hàng'}
                      {/* Chọn điểm giao hàng */}
                    </Text>
                  </View>
                  <Image
                    resizeMode="contain"
                    style={{
                      width: 22,
                      height: 22,
                      tintColor: COLORS.primary,
                    }}
                    source={icons.rightArrow}
                  />
                </View>
              </TouchableOpacity>
            </View>
            <View style={styles.logout}>
              <TouchableOpacity
                onPress={() => {
                  setOpen(!open);
                }}>
                <Image
                  resizeMode="contain"
                  style={{width: 38, height: 38}}
                  source={icons.userCircle}
                />
              </TouchableOpacity>
              {open && (
                <TouchableOpacity
                  style={{
                    position: 'absolute',
                    bottom: -30,
                    left: -12,
                    zIndex: 100,
                    width: 75,
                    height: 35,
                    justifyContent: 'center',
                    alignItems: 'center',
                    borderRadius: 10,
                    backgroundColor: 'rgb(240,240,240)',
                  }}
                  onPress={() => {
                    auth()
                      .signOut()
                      .then(async () => {
                        await AsyncStorage.removeItem('userInfo');
                      })
                      .catch(e => console.log(e));
                  }}>
                  <Text style={{color: 'red', fontWeight: 'bold'}}>
                    Đăng xuất
                  </Text>
                </TouchableOpacity>
              )}
            </View>
          </View>
          <View
            style={{
              flexDirection: 'row',
            }}>
            <View style={{flex: 6}}>
              <ScrollView horizontal showsHorizontalScrollIndicator={false}>
                {orderGroupAreaState.map((item, index) => (
                  <TouchableOpacity
                    key={index}
                    onPress={() => {
                      setCurrentStatus(item);
                    }}>
                    <View
                      style={[
                        {
                          paddingTop: 15,
                          paddingHorizontal: 15,
                          paddingBottom: 15,
                        },
                        currentStatus.display === item.display && {
                          borderBottomColor: COLORS.primary,
                          borderBottomWidth: 2,
                        },
                      ]}>
                      <Text
                        style={{
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color:
                            currentStatus.display === item.display
                              ? COLORS.primary
                              : 'black',
                          fontWeight:
                            currentStatus.display === item.display
                              ? 'bold'
                              : 400,
                        }}>
                        {item.display}
                      </Text>
                    </View>
                  </TouchableOpacity>
                ))}
              </ScrollView>
            </View>
            <View
              style={{
                justifyContent: 'center',
                alignItems: 'flex-end',
                flex: 1,
              }}>
              <TouchableOpacity
                onPress={() => {
                  setSortModalVisible(true);
                }}>
                <Image
                  resizeMode="contain"
                  style={{
                    height: 35,
                    tintColor: COLORS.primary,
                    width: 35,
                    marginHorizontal: '1%',
                  }}
                  source={icons.filter}
                />
              </TouchableOpacity>
            </View>
          </View>
          <View style={styles.body}>
            {/* Order list */}
            {orderGroupList.length === 0 ? (
              <View style={{alignItems: 'center', justifyContent: 'center'}}>
                <Image
                  style={{width: '100%', height: '50%'}}
                  resizeMode="contain"
                  source={CartEmpty}
                />
                <Text
                  style={{
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    // color: 'black',
                    fontWeight: 'bold',
                  }}>
                  Không có nhóm nào
                </Text>
              </View>
            ) : (
              <View style={{marginTop: 10, marginBottom: 100}}>
                <FlatList
                  data={orderGroupList.filter(group => {
                    if (currentStatus.value === 'PROCESSING') {
                      return group.productConsolidationArea === null;
                    }
                    if (currentStatus.value === 'PACKAGING') {
                      return (
                        group.productConsolidationArea !== null &&
                        group.orderList.find(order => order.status === 1) !==
                          undefined
                      );
                    }
                    if (currentStatus.value === 'PACKAGED') {
                      return (
                        group.productConsolidationArea !== null &&
                        group.orderList.find(order => order.status === 2) !==
                          undefined
                      );
                    }
                  })}
                  renderItem={data => (
                    <View
                      key={data.item.id}
                      style={{
                        marginBottom: 20,
                      }}>
                      {/* Group detail */}
                      <View>
                        <View
                          style={{
                            backgroundColor: COLORS.secondary,
                            marginBottom: 5,
                            alignItems: 'center',
                            borderRadius: 5,
                            padding: 10,
                            flexDirection: 'row',
                          }}>
                          <TouchableOpacity
                            onPress={() => {
                              setOrderGroupList(
                                orderGroupList.map(group => {
                                  if (group.id === data.item.id) {
                                    group.isExpand = !group.isExpand;
                                  }
                                  return group;
                                }),
                              );
                            }}>
                            <Image
                              resizeMode="contain"
                              style={{
                                width: 20,
                                height: 20,
                                tintColor: 'white',
                              }}
                              source={
                                data.item.isExpand ? icons.plus : icons.minus
                              }
                            />
                          </TouchableOpacity>
                          <View
                            style={{
                              flexDirection: 'row',
                              alignItems: 'center',
                              flexGrow: 1,
                              flexShrink: 1,
                              justifyContent: 'center',
                            }}>
                            {data.item.isExpand ? (
                              <Text
                                style={{
                                  fontSize: 18,
                                  fontWeight: 'bold',
                                  fontFamily: 'Roboto',
                                  color: 'white',
                                }}>
                                {data.item.timeFrame.fromHour +
                                  '-' +
                                  data.item.timeFrame.toHour +
                                  ' ' +
                                  format(
                                    Date.parse(data.item.deliverDate),
                                    'dd/MM/yyyy',
                                  )}
                              </Text>
                            ) : (
                              <View style={{flexDirection: 'column', gap: 8}}>
                                <Text
                                  style={{
                                    fontSize: 18,
                                    fontWeight: 'bold',
                                    fontFamily: 'Roboto',
                                    color: 'white',
                                  }}>
                                  Khung giờ:{' '}
                                  {data.item.timeFrame.fromHour +
                                    '-' +
                                    data.item.timeFrame.toHour}
                                </Text>
                                <Text
                                  style={{
                                    fontSize: 18,
                                    fontWeight: 'bold',
                                    fontFamily: 'Roboto',
                                    color: 'white',
                                  }}>
                                  Ngày giao:{' '}
                                  {format(
                                    Date.parse(data.item.deliverDate),
                                    'dd/MM/yyyy',
                                  )}
                                </Text>
                              </View>
                            )}
                          </View>
                          {data.item.orderList.filter(
                            order => order.status === 2,
                          ).length === 0 && (
                            <TouchableOpacity
                              onPress={() =>
                                handleOpenEditModal(
                                  data.item.id,
                                  data.item.productConsolidationArea === null,
                                  data.item.pickupPoint.id,
                                )
                              }>
                              <Image
                                resizeMode="contain"
                                style={{
                                  width: 20,
                                  height: 20,
                                  tintColor: 'white',
                                }}
                                source={icons.edit}
                              />
                            </TouchableOpacity>
                          )}
                        </View>

                        {/* order list in group */}
                        {data.item.isExpand &&
                          data.item.orderList != null &&
                          data.item.orderList.length > 0 &&
                          data.item.orderList.map((order, index) => (
                            <TouchableOpacity
                              style={{
                                paddingHorizontal: 0,
                                paddingVertical: 10,
                              }}
                              onPress={() => {
                                navigation.navigate('OrderDetail', {
                                  id: data.item.id,
                                  orderSuccess: false,
                                });
                              }}
                              key={index}>
                              <View
                                style={{
                                  flexDirection: 'row',
                                  alignItems: 'center',
                                  justifyContent: 'space-between',
                                  backgroundColor: 'rgb(240,240,240)',
                                  paddingHorizontal: 10,
                                  paddingVertical: 10,
                                  borderRadius: 10,
                                }}>
                                <View style={{flexDirection: 'column', gap: 8}}>
                                  <Text
                                    style={{
                                      fontSize: 20,
                                      fontWeight: 'bold',
                                      fontFamily: 'Roboto',
                                      color: COLORS.primary,
                                    }}>
                                    {order?.status === 0 && 'Chờ đóng gói'}
                                    {order?.status === 1 && 'Đang đóng gói'}
                                    {order?.status === 2 && 'Đã đóng gói'}
                                  </Text>
                                  <Text
                                    style={{
                                      fontSize: 17,
                                      fontWeight: 'bold',
                                      fontFamily: 'Roboto',
                                      color: 'black',
                                    }}>
                                    Ngày đặt :{' '}
                                    {format(
                                      Date.parse(order?.createdTime),
                                      'dd/MM/yyyy',
                                    )}
                                  </Text>
                                  <Text
                                    style={{
                                      fontSize: 17,
                                      fontWeight: 'bold',
                                      fontFamily: 'Roboto',
                                      color: 'black',
                                    }}>
                                    Ngày giao :{' '}
                                    {format(
                                      Date.parse(order?.deliveryDate),
                                      'dd/MM/yyyy',
                                    )}
                                  </Text>
                                  <Text
                                    style={{
                                      fontSize: 17,
                                      fontWeight: 'bold',
                                      fontFamily: 'Roboto',
                                      color: 'black',
                                    }}>
                                    Tổng tiền:{' '}
                                    {order?.totalPrice?.toLocaleString(
                                      'vi-VN',
                                      {
                                        style: 'currency',
                                        currency: 'VND',
                                      },
                                    )}
                                  </Text>
                                  <Text
                                    style={{
                                      fontSize: 17,
                                      fontWeight: 'bold',
                                      fontFamily: 'Roboto',
                                      color: 'black',
                                    }}>
                                    Nhân viên đóng gói:{' '}
                                    {order?.packager === null
                                      ? 'Chưa có'
                                      : order?.packager.fullName}
                                  </Text>
                                </View>
                                <Image
                                  resizeMode="contain"
                                  style={{
                                    width: 30,
                                    height: 30,
                                    tintColor: COLORS.primary,
                                  }}
                                  source={icons.rightArrow}
                                />
                              </View>
                            </TouchableOpacity>
                          ))}
                      </View>
                      {/* *********************** */}
                    </View>
                  )}
                  // renderHiddenItem={(data, rowMap) => (
                  //   <View
                  //     style={{
                  //       flexDirection: 'row',
                  //       justifyContent: 'flex-end',
                  //       height: '89%',
                  //       // marginVertical: '2%',
                  //     }}>
                  //     <TouchableOpacity
                  //       style={{
                  //         width: 120,
                  //         height: '100%',
                  //         backgroundColor: COLORS.primary,
                  //         borderRadius: 10,
                  //         // flex: 1,
                  //         alignItems: 'center',
                  //         justifyContent: 'center',
                  //       }}
                  //       onPress={() => {
                  //         setVisible(true);
                  //         // console.log(data.item.id);
                  //         setOrder(data.item);
                  //       }}>
                  //       <View>
                  //         {data.item?.status === 0 && (
                  //           <Image
                  //             source={icons.packaging}
                  //             resizeMode="contain"
                  //             style={{
                  //               width: 40,
                  //               height: 40,
                  //               tintColor: 'white',
                  //             }}
                  //           />
                  //         )}
                  //         {data.item?.status === 1 && (
                  //           <Image
                  //             source={icons.packaged}
                  //             resizeMode="contain"
                  //             style={{
                  //               width: 55,
                  //               height: 55,
                  //               tintColor: 'white',
                  //             }}
                  //           />
                  //         )}
                  //       </View>
                  //     </TouchableOpacity>
                  //   </View>
                  // )}
                />
              </View>
            )}

            {/* Modal Sort */}
            <Modal
              animationType="fade"
              transparent={true}
              visible={sortModalVisible}>
              <View
                // onPress={handleCloseSortModal}
                style={styles.centeredView}>
                <View style={styles.modalView}>
                  <View
                    style={{
                      flexDirection: 'row',
                      justifyContent: 'space-between',
                    }}>
                    <Text
                      style={{
                        color: 'black',
                        fontSize: 20,
                        fontWeight: 700,
                        textAlign: 'center',
                        paddingBottom: 20,
                      }}>
                      Bộ lọc tìm kiếm
                    </Text>
                    <TouchableOpacity onPress={handleCloseSortModal}>
                      <Image
                        resizeMode="contain"
                        style={{
                          width: 20,
                          height: 20,
                          tintColor: 'grey',
                        }}
                        source={icons.close}
                      />
                    </TouchableOpacity>
                  </View>
                  <Text
                    style={{
                      color: 'black',
                      fontSize: 16,
                      fontWeight: 700,
                    }}>
                    Sắp xếp theo
                  </Text>
                  <View
                    style={{
                      flexDirection: 'row',
                      flexWrap: 'wrap',
                      marginVertical: 10,
                    }}>
                    {selectSort.map((item, index) => (
                      <TouchableOpacity
                        key={index}
                        onPress={() => {
                          // const newArray = selectSort.map(i => {
                          //   if (i.id === item.id) {
                          //     if (i.active === true) {
                          //       return {...i, active: false};
                          //     } else {
                          //       return {...i, active: true};
                          //     }
                          //   }
                          //   return {...i, active: false};
                          // });
                          // console.log(newArray);

                          setTempSelectedSortId(
                            tempSelectedSortId === item.id ? '' : item.id,
                          );
                        }}
                        style={
                          tempSelectedSortId === item.id
                            ? {
                                borderColor: COLORS.primary,
                                borderWidth: 1,
                                borderRadius: 10,
                                margin: 5,
                              }
                            : {
                                borderColor: '#c8c8c8',
                                borderWidth: 0.2,
                                borderRadius: 10,
                                margin: 5,
                              }
                        }>
                        <Text
                          style={
                            tempSelectedSortId === item.id
                              ? {
                                  width: 150,
                                  paddingVertical: 10,
                                  textAlign: 'center',
                                  color: COLORS.primary,

                                  fontSize: 12,
                                }
                              : {
                                  width: 150,
                                  paddingVertical: 10,
                                  textAlign: 'center',
                                  color: 'black',

                                  fontSize: 12,
                                }
                          }>
                          {item.name}
                        </Text>
                      </TouchableOpacity>
                    ))}
                  </View>
                  <Text
                    style={{
                      color: 'black',
                      fontSize: 16,
                      fontWeight: 700,
                    }}>
                    Chọn khung giờ
                  </Text>
                  <View
                    style={{
                      flexDirection: 'row',
                      flexWrap: 'wrap',
                      marginVertical: 10,
                    }}>
                    {timeFrameList &&
                      timeFrameList.map(item => (
                        <TouchableOpacity
                          key={item.id}
                          onPress={() =>
                            item.id === tempSelectedTimeFrameId
                              ? setTempSelectedTimeFrameId('')
                              : setTempSelectedTimeFrameId(item.id)
                          }
                          style={
                            item.id === tempSelectedTimeFrameId
                              ? {
                                  borderColor: COLORS.primary,
                                  borderWidth: 1,
                                  borderRadius: 10,
                                  margin: 5,
                                }
                              : {
                                  borderColor: '#c8c8c8',
                                  borderWidth: 0.2,
                                  borderRadius: 10,
                                  margin: 5,
                                }
                          }>
                          <Text
                            style={
                              item.id === tempSelectedTimeFrameId
                                ? {
                                    width: 150,
                                    paddingVertical: 10,
                                    textAlign: 'center',
                                    color: COLORS.primary,

                                    fontSize: 12,
                                  }
                                : {
                                    width: 150,
                                    paddingVertical: 10,
                                    textAlign: 'center',
                                    color: 'black',

                                    fontSize: 12,
                                  }
                            }>
                            {item.fromHour.slice(0, 5)} đến{' '}
                            {item.toHour.slice(0, 5)}
                          </Text>
                        </TouchableOpacity>
                      ))}
                  </View>
                  <Text
                    style={{
                      color: 'black',
                      fontSize: 16,
                      fontWeight: 700,
                    }}>
                    Chọn ngày giao hàng
                  </Text>
                  <View
                    style={{
                      flexDirection: 'row',
                      flexWrap: 'wrap',
                      marginVertical: 10,
                    }}>
                    <DatePicker
                      date={tempSelectedDate}
                      mode="date"
                      androidVariant="nativeAndroid"
                      onDateChange={setTempSelectedDate}
                    />
                  </View>

                  <View
                    style={{
                      flexDirection: 'row',
                      justifyContent: 'center',
                      marginTop: '5%',
                    }}>
                    <TouchableOpacity
                      style={{
                        width: '50%',
                        paddingHorizontal: 15,
                        paddingVertical: 10,
                        backgroundColor: 'white',
                        borderRadius: 10,
                        borderColor: COLORS.primary,
                        borderWidth: 0.5,
                        marginRight: '2%',
                      }}
                      onPress={handleClearSortModal}>
                      <Text
                        style={{
                          color: COLORS.primary,
                          fontWeight: 'bold',
                          textAlign: 'center',
                        }}>
                        Thiết lập lại
                      </Text>
                    </TouchableOpacity>

                    <TouchableOpacity
                      style={{
                        width: '50%',
                        paddingHorizontal: 15,
                        paddingVertical: 10,
                        backgroundColor: COLORS.primary,
                        color: 'white',
                        borderRadius: 10,
                      }}
                      onPress={handleApplyFilter}>
                      <Text style={styles.textStyle}>Áp dụng</Text>
                    </TouchableOpacity>
                  </View>
                </View>
              </View>
            </Modal>

            {/* Modal confirm packaged */}
            <Modal
              animationType="fade"
              transparent={true}
              visible={editStatusPackagedModalVisible}
              onRequestClose={handleCloseEditModal}>
              <View style={styles.centeredView}>
                <View style={styles.modalView}>
                  <View
                    style={{
                      flexDirection: 'row',
                      justifyContent: 'space-between',
                    }}>
                    <Text
                      style={{
                        color: 'black',
                        fontSize: 20,
                        fontWeight: 700,
                        textAlign: 'center',
                        paddingBottom: 20,
                      }}>
                      Xác nhận đóng gói
                    </Text>
                    <TouchableOpacity onPress={handleCloseEditModal}>
                      <Image
                        resizeMode="contain"
                        style={{
                          width: 20,
                          height: 20,
                          tintColor: 'grey',
                        }}
                        source={icons.close}
                      />
                    </TouchableOpacity>
                  </View>

                  <Text>Xác nhận đã đóng hoàn thành đóng gói cho nhóm đơn này ?</Text>

                  <View
                    style={{
                      flexDirection: 'row',
                      justifyContent: 'center',
                      marginTop: '5%',
                    }}>
                    <TouchableOpacity
                      style={{
                        width: '50%',
                        paddingHorizontal: 15,
                        paddingVertical: 10,
                        backgroundColor: 'white',
                        borderRadius: 10,
                        borderColor: COLORS.primary,
                        borderWidth: 0.5,
                        marginRight: '2%',
                      }}
                      onPress={handleCloseEditModal}>
                      <Text
                        style={{
                          color: COLORS.primary,
                          fontWeight: 'bold',
                          textAlign: 'center',
                        }}>
                        Trở về
                      </Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                      style={{
                        width: '50%',
                        paddingHorizontal: 15,
                        paddingVertical: 10,
                        backgroundColor: COLORS.primary,
                        color: 'white',
                        borderRadius: 10,
                      }}
                      onPress={handleSubmitEditStatusPackaged}>
                      <Text style={styles.textStyle}>Xác nhận</Text>
                    </TouchableOpacity>
                  </View>
                </View>
              </View>
            </Modal>

            {/* Modal response dialog */}
            <Modal
              animationType="fade"
              transparent={true}
              visible={openResponseDialog}
              onRequestClose={() => {
                setOpenResponseDialog(false);
              }}>
              <View style={styles.centeredView}>
                <View style={styles.modalView}>
                  <View
                    style={{
                      flexDirection: 'row',
                      justifyContent: 'space-between',
                    }}>
                    <Text
                      style={{
                        color: 'black',
                        fontSize: 20,
                        fontWeight: 700,
                        textAlign: 'center',
                        paddingBottom: 20,
                      }}>
                      {messageResult}
                    </Text>
                    {/* <TouchableOpacity
                      onPress={() => {
                        setOpenResponseDialog(false);
                      }}>
                      <Image
                        resizeMode="contain"
                        style={{
                          width: 20,
                          height: 20,
                          tintColor: 'grey',
                        }}
                        source={icons.close}
                      />
                    </TouchableOpacity> */}
                  </View>

                  <View
                    style={{
                      flexDirection: 'row',
                      justifyContent: 'center',
                      marginTop: '5%',
                    }}>
                    <TouchableOpacity
                      style={{
                        width: '100%',
                        paddingHorizontal: 15,
                        paddingVertical: 10,
                        backgroundColor: COLORS.primary,
                        color: 'white',
                        borderRadius: 10,
                      }}
                      onPress={() => {
                        setOpenResponseDialog(false);
                      }}>
                      <Text style={styles.textStyle}>Đóng</Text>
                    </TouchableOpacity>
                  </View>
                </View>
              </View>
            </Modal>

            {/* Modal Edit Consolidation Area */}
            <Modal
              animationType="fade"
              transparent={true}
              visible={editAreaModalVisible}
              onRequestClose={handleCloseEditModal}>
              <View style={styles.centeredView}>
                <View style={styles.modalView}>
                  <View
                    style={{
                      flexDirection: 'row',
                      justifyContent: 'space-between',
                    }}>
                    <Text
                      style={{
                        color: 'black',
                        fontSize: 20,
                        fontWeight: 700,
                        textAlign: 'center',
                        paddingBottom: 20,
                      }}>
                      Chọn điểm tập kết
                    </Text>
                    <TouchableOpacity onPress={handleCloseEditModal}>
                      <Image
                        resizeMode="contain"
                        style={{
                          width: 20,
                          height: 20,
                          tintColor: 'grey',
                        }}
                        source={icons.close}
                      />
                    </TouchableOpacity>
                  </View>
                  <FlatList
                    style={{maxHeight: 200}}
                    data={consolidationAreaList}
                    renderItem={data => (
                      <TouchableOpacity
                        key={data.item.id}
                        onPress={() => {
                          setSelectedConsolidationAreaId(data.item.id);
                        }}
                        style={{
                          paddingVertical: 15,
                          borderTopColor: '#decbcb',
                          borderTopWidth: 0.75,
                        }}>
                        <View
                          style={{
                            flexDirection: 'row',
                            alignItems: 'center',
                            gap: 15,
                            flex: 1,
                            justifyContent: 'space-between',
                          }}>
                          <Image
                            resizeMode="contain"
                            style={{width: 20, height: 20}}
                            source={icons.location}
                            tintColor={
                              data.item.id === selectedConsolidationAreaId
                                ? COLORS.secondary
                                : 'black'
                            }
                          />
                          <Text
                            style={{
                              fontSize: 16,
                              color:
                                data.item.id === selectedConsolidationAreaId
                                  ? COLORS.secondary
                                  : 'black',
                              fontFamily: 'Roboto',
                              textDecorationColor: 'red',
                              flexShrink: 1,
                            }}>
                            {data.item.address}
                          </Text>
                        </View>
                      </TouchableOpacity>
                    )}
                  />
                  <View
                    style={{
                      flexDirection: 'row',
                      justifyContent: 'center',
                      marginTop: '5%',
                    }}>
                    <TouchableOpacity
                      style={{
                        width: '100%',
                        paddingHorizontal: 15,
                        paddingVertical: 10,
                        backgroundColor:
                          selectedConsolidationAreaId === ''
                            ? COLORS.light_green
                            : COLORS.primary,
                        color: 'white',
                        borderRadius: 10,
                      }}
                      disabled={selectedConsolidationAreaId === ''}
                      onPress={handleSubmitAreaEditModal}>
                      <Text style={styles.textStyle}>Xác nhận</Text>
                    </TouchableOpacity>
                  </View>
                </View>
              </View>
            </Modal>
          </View>
        </View>
      </View>
    </TouchableWithoutFeedback>
  );
};

export default OrderGroupForOrderStaff;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
  },
  header: {
    flex: 2.2,
    // backgroundColor: 'orange',
    paddingHorizontal: 20,
  },
  body: {
    flex: 7,
    // backgroundColor: 'pink',
    paddingHorizontal: 5,
  },
  areaAndLogout: {
    paddingTop: 10,
    flexDirection: 'row',
  },
  pickArea: {
    paddingVertical: 6,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  area: {
    flex: 7,
    // backgroundColor: 'white',
  },
  logout: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'flex-end',
    marginLeft: 10,
  },
  pickAreaItem: {
    flexDirection: 'row',
    gap: 10,
    alignItems: 'center',
    width: '80%',
  },
  centeredView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    // marginTop: 22,
    backgroundColor: 'rgba(50,50,50,0.5)',
  },
  modalView: {
    margin: 20,
    backgroundColor: 'white',
    borderRadius: 20,
    padding: 20,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
  },
  textStyle: {
    color: 'white',
    fontWeight: 'bold',
    textAlign: 'center',
  },
});