/* eslint-disable prettier/prettier */
/* eslint-disable react-native/no-inline-styles */
/* eslint-disable react/no-unstable-nested-components */
import React, { useCallback, useEffect, useState } from 'react';
import {
  Text,
  View,
  StyleSheet,
  SafeAreaView,
  Image,
  TouchableOpacity,
  ScrollView,
  Dimensions,
} from 'react-native';
import Categories from '../components/Categories';
import DiscountRow from '../components/DiscountRow';
import { COLORS, FONTS } from '../constants/theme';
import { icons } from '../constants';
import dayjs from 'dayjs';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { API } from '../constants/api';
import { useFocusEffect } from '@react-navigation/native';
import Toast from 'react-native-toast-message';
import LoadingScreen from '../components/LoadingScreen';
import Modal, {
  ModalFooter,
  ModalButton,
  ScaleAnimation,
} from 'react-native-modals';
import Empty from '../assets/image/search-empty.png';
import database from '@react-native-firebase/database';
import Swiper from 'react-native-swiper';
import Geolocation from '@react-native-community/geolocation';

const Home = ({ navigation }) => {
  const [categories, setCategories] = useState([]);
  const [subCategories, setSubCategories] = useState([]);
  const [currentCate, setCurrentCate] = useState(null);
  const [productsByCategory, setProductsByCategory] = useState([]);
  const [discountsByCategory, setDiscountsByCategory] = useState([]);
  const [page, setPage] = useState(1);
  const [totalPage, setTotalPage] = useState(1);
  const [cartList, setCartList] = useState([]);
  const [loading, setLoading] = useState(false);
  const [openAuthModal, setOpenAuthModal] = useState(false);
  const [pickupPoint, setPickupPoint] = useState(null);
  const [imageDiscountForSlider, setImageDiscountForSlider] = useState([]);

  const showToast = () => {
    Toast.show({
      type: 'success',
      text1: 'Thành công',
      text2: 'Thêm sản phẩm vào giỏ hàng thành công 👋',
      visibilityTime: 1000,
    });
  };

  // console.log(cartList);

  // system status check
  useFocusEffect(
    useCallback(() => {
      database().ref(`systemStatus`).off('value');
      database()
        .ref('systemStatus')
        .on('value', async snapshot => {
          if (snapshot.val() === 0) {
            navigation.reset({
              index: 0,
              routes: [{ name: 'Initial' }],
            });
          } else {
            // setSystemStatus(snapshot.val());
          }
        });
    }, []),
  );

  useFocusEffect(
    useCallback(() => {
      setLoading(true);
      // Get pickup point from AS
      (async () => {
        try {
          setLoading(true);
          const value = await AsyncStorage.getItem('PickupPoint');
          if (value == null) {
            AsyncStorage.removeItem('PickupPoint');
            try {
              Geolocation.getCurrentPosition(
                position => {
                  const currentLongitude = position.coords.longitude;
                  const currentLatitude = position.coords.latitude;
                  // get nearest pick up point by current lat,long
                  fetch(
                    `${API.baseURL}/api/pickupPoint/getWithSortAndSuggestion?latitude=${currentLatitude}&longitude=${currentLongitude}`,
                  )
                    .then(res => res.json())
                    .then(response => {
                      setPickupPoint(response.sortedPickupPointSuggestionList[0]);
                      AsyncStorage.setItem(
                        'PickupPoint',
                        JSON.stringify(response.sortedPickupPointSuggestionList[0]),
                      );
                      // setLoading(false);
                    })
                    .catch(err => {
                      console.log(err);
                      setLoading(false);
                    }
                    );
                },
                error => {
                  console.log(error.message);
                },
                {
                  enableHighAccuracy: true,
                },
              );
              // await AsyncStorage.setItem(
              //   'PickupPoint',
              //   JSON.stringify(pickupPoint),
              // );
              setCartList([]);
              // setLoading(false);
            } catch (error) {
              setLoading(false);
              console.log(error);
            }
          } else {
            setPickupPoint(value ? JSON.parse(value) : pickupPoint);
            const cartListNew = await AsyncStorage.getItem(
              'CartList' + JSON.parse(value).id,
            );
            setCartList(cartListNew ? JSON.parse(cartListNew) : []);
            // setLoading(false);
          }
        } catch (err) {
          console.log(err);
          setLoading(false);
        }
      })();
    }, []),
  );

  useEffect(() => {
    setLoading(true);
    if (pickupPoint) {
      fetch(
        `${API.baseURL}/api/product/getAllCategory?pickupPointId=${pickupPoint.id}`,
      )
        .then(res => res.json())
        .then(data => {
          if (data.error) {
            setCategories([]);
            return;
          }
          if (data.length === 0) {
            setCategories([]);
            setCurrentCate(null);
            setSubCategories([]);
            setDiscountsByCategory([]);
            setImageDiscountForSlider([]);
            setProductsByCategory([]);
          } else {
            setCategories(data);
            setCurrentCate(data ? data[0]?.id : null);
          }
          // setLoading(false);
        })
        .catch(err => {
          console.log(err);
          setLoading(false);
        });
    }
  }, [pickupPoint]);

  useEffect(() => {
    if (currentCate && pickupPoint) {
      setLoading(true);
      fetch(
        `${API.baseURL}/api/product/getProductsForCustomer?productCategoryId=${currentCate}&pickupPointId=${pickupPoint?.id}&page=0&limit=10&quantitySortType=DESC&expiredSortType=ASC`,
      )
        .then(res => res.json())
        .then(data => {
          setProductsByCategory(data.productList);
          setPage(1);
          setTotalPage(data.totalPage);
          // Fetch discount
          fetch(
            `${API.baseURL}/api/discount/getDiscountsForCustomer?fromPercentage=0&toPercentage=100&productCategoryId=${currentCate}&page=0&limit=5&expiredSortType=ASC`,
          )
            .then(res => res.json())
            .then(data => {
              setDiscountsByCategory(data);
              const imagesList = [];
              data.map((item) => {
                imagesList.push(item.imageUrl);
              });
              setImageDiscountForSlider(imagesList);
              setLoading(false);
            })
            .catch(err => {
              console.log(err);
              setLoading(false);
            });
        })
        .catch(err => {
          console.log(err);
          setLoading(false);
        });
      categories.map(item => {
        item.id === currentCate && setSubCategories(item.productSubCategories);
      });
    }
  }, [currentCate, pickupPoint]);

  const handleAddToCart = async data => {
    try {
      const user = await AsyncStorage.getItem('userInfo');
      if (!user) {
        setOpenAuthModal(true);
        return;
      }
      const jsonValue = await AsyncStorage.getItem('CartList');
      let newCartList = jsonValue ? JSON.parse(jsonValue) : [];
      const itemExisted = newCartList.some(item => item.id === data.id);
      if (itemExisted) {
        const index = newCartList.findIndex(item => item.id === data.id);
        newCartList[index].cartQuantity = newCartList[index].cartQuantity + 1;
        setCartList(newCartList);
        await AsyncStorage.setItem('CartList', JSON.stringify(newCartList));
        showToast();
        return;
      }

      const cartData = { ...data, isChecked: false, cartQuantity: 1 };
      newCartList = [...newCartList, cartData];
      setCartList(newCartList);
      await AsyncStorage.setItem('CartList', JSON.stringify(newCartList));
      showToast();
    } catch (error) {
      console.log(error);
    }
  };

  const Item = ({ data }) => {
    return (
      <View style={styles.itemContainer}>
        <TouchableOpacity
          key={data.id}
          onPress={() => {
            navigation.navigate('ProductDetails', {
              product: data,
              pickupPointId: pickupPoint.id,
            });
          }}
          style={{
            flexDirection: 'row',
          }}>
          {/* Image Product */}
          <Image
            resizeMode="contain"
            source={{
              uri: data?.imageUrlImageList[0].imageUrl,
            }}
            style={styles.itemImage}
          />

          <View
            style={{
              justifyContent: 'center',
              flex: 1,
              marginRight: 10,
              marginTop: 5,
            }}>
            <Text
              numberOfLines={1}
              style={{
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.045,
                fontWeight: 700,
                maxWidth: '95%',
                color: 'black',
              }}>
              {data.name}
            </Text>
            <Text
              style={{
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.045,
                marginTop: 8,
                marginBottom: 10,
              }}>
              HSD:{' '}
              {dayjs(data?.nearestExpiredBatch.expiredDate).format(
                'DD/MM/YYYY',
              )}
            </Text>

            <View style={{ flexDirection: 'row', paddingBottom: '2%', }}>
              <Text
                style={{
                  maxWidth: '70%',
                  fontSize: Dimensions.get('window').width * 0.035,
                  lineHeight: 20,
                  fontWeight: 'bold',
                  fontFamily: FONTS.fontFamily,
                  textDecorationLine: 'line-through'
                }}>
                {data?.priceListed.toLocaleString('vi-VN', {
                  currency: 'VND',
                })}
              </Text>
              <Text
                style={{
                  fontSize: Dimensions.get('window').width * 0.03,
                  lineHeight: 13,
                  fontWeight: 600,
                  fontFamily: FONTS.fontFamily,
                }}>
                ₫
              </Text>
            </View>

            <View style={{ flexDirection: 'row' }}>
              <Text
                style={{
                  maxWidth: '70%',
                  fontSize: Dimensions.get('window').width * 0.045,
                  lineHeight: 20,
                  color: COLORS.secondary,
                  fontWeight: 'bold',
                  fontFamily: FONTS.fontFamily,
                }}>
                {data?.nearestExpiredBatch.price.toLocaleString('vi-VN', {
                  currency: 'VND',
                })}
              </Text>
              <Text
                style={{
                  fontSize: Dimensions.get('window').width * 0.03,
                  lineHeight: 13,
                  color: COLORS.secondary,
                  fontWeight: 600,
                  fontFamily: FONTS.fontFamily,
                }}>
                ₫
              </Text>
            </View>

            {/* Button buy */}
            {/* <TouchableOpacity onPress={() => handleAddToCart(data)}>
              <Text
                style={{
                  maxWidth: 150,
                  maxHeight: 40,
                  padding: 10,
                  backgroundColor: COLORS.primary,
                  borderRadius: 10,
                  textAlign: 'center',
                  color: '#ffffff',
                  fontFamily: FONTS.fontFamily,
                }}>
                Thêm vào giỏ hàng
              </Text>
            </TouchableOpacity> */}
          </View>

        </TouchableOpacity>
      </View>
    );
  };

  const SubCategory = ({ data }) => {
    return (
      <TouchableOpacity
        onPress={() => {
          navigation.navigate('ProductsBySubCategories', {
            subCategory: data,
          });
        }}
        style={{
          marginTop: 20,
          // marginLeft: 15,
          // marginRight: 20,
          alignItems: 'center',
          width: (Dimensions.get('window').width - 20 * 2 - 40 - 21) / 4,
          shadowColor: '#000',
          shadowOffset: {
            width: 0,
            height: 3,
          },
          shadowOpacity: 0.27,
          shadowRadius: 4.65,
          elevation: 10,
        }}>
        <Image
          resizeMode="contain"
          source={{
            uri: data?.imageUrl,
          }}
          style={{
            width: Dimensions.get('window').width * 0.12,
            height: 50,
          }}
        />
        <Text
          numberOfLines={2}
          style={{
            color: 'black',
            fontFamily: FONTS.fontFamily,
            fontSize: Dimensions.get('window').width * 0.03,
            marginTop: 10,
            textAlign: 'center'
          }}>
          {data.name}
        </Text>
      </TouchableOpacity>
    );
  };

  const SearchBar = () => {
    return (
      <TouchableOpacity
        style={{
          backgroundColor: '#f5f5f5',
          width: '80%',
          height: 45,
          borderRadius: 40,
          paddingLeft: '5%',
          marginTop: '5%',
          marginLeft: '5%',
          marginBottom: '5%',
          flexDirection: 'row',
        }}
        onPress={() => {
          navigation.navigate('Search');
        }}>
        <View
          style={{
            justifyContent: 'center',
            alignItems: 'center',
            height: 40,
            flexWrap: 'wrap',
            paddingLeft: 5,
            paddingTop: 2,
          }}>
          <Image
            resizeMode="contain"
            style={{
              width: Dimensions.get('window').width * 0.1,
              height: 20,
            }}
            source={icons.search}
          />

          <Text
            style={{
              fontFamily: FONTS.fontFamily,
              fontSize: Dimensions.get('window').width * 0.045,
              paddingLeft: 15,
            }}>
            Bạn cần tìm gì ?
          </Text>
        </View>
      </TouchableOpacity>
    );
  };

  const SelectPickupPointBar = () => {
    return (
      <View
        style={{
          paddingHorizontal: 20,
          paddingTop: 10,
        }}>
        <Text style={{ fontSize: Dimensions.get('window').width * 0.04, fontFamily: FONTS.fontFamily }}>
          Vị trí mua hàng hiện tại:
        </Text>
        <TouchableOpacity
          onPress={() => {
            setCurrentCate(null);
            navigation.navigate('ChangePickupPoint', {
              pickupPoint: pickupPoint,
              setPickupPoint,
            });
          }}>
          <View
            style={{
              paddingVertical: 6,
              flexDirection: 'row',
              alignItems: 'center',
              justifyContent: 'space-between',
            }}>
            <View
              style={{
                flexDirection: 'row',
                alignItems: 'center',
                width: '95%',
              }}>
              <View
                style={{
                  flexDirection: 'row',
                  gap: 10,
                  alignItems: 'center',
                  width: '80%',
                }}>
                <Image
                  resizeMode="contain"
                  style={{ width: Dimensions.get('window').width * 0.1, height: 20, tintColor: COLORS.primary }}
                  source={icons.location}
                />
                <Text
                  style={{
                    fontSize: Dimensions.get('window').width * 0.04,
                    fontFamily: 'Roboto',
                    color: 'black',
                    fontWeight: 'bold',
                  }}>
                  {pickupPoint ? pickupPoint.address : ''}
                </Text>
              </View>
            </View>
          </View>
        </TouchableOpacity>
      </View>
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Pickup point */}
      <SelectPickupPointBar />

      {/* Search */}
      <View style={{ flexDirection: 'row', gap: 10, alignItems: 'center' }}>
        <SearchBar />
        <TouchableOpacity
          onPress={async () => {
            try {
              const user = await AsyncStorage.getItem('userInfo');
              if (!user) {
                setOpenAuthModal(true);
                return;
              }
              navigation.navigate('Cart');
            } catch (error) { }
          }}>
          <Image
            resizeMode="contain"
            style={{
              height: 40,
              tintColor: COLORS.primary,
              width: Dimensions.get('window').width * 0.08,
            }}
            source={icons.cart}
          />
          {cartList.length !== 0 && (
            <View
              style={{
                position: 'absolute',
                top: 0,
                right: -10,
                backgroundColor: COLORS.primary,
                borderRadius: 50,
                width: 20,
                height: 20,
                alignItems: 'center',
                justifyContent: 'center',
              }}>
              <Text
                style={{ fontSize: 12, color: 'white', fontFamily: 'Roboto' }}>
                {cartList.length}
              </Text>
            </View>
          )}
        </TouchableOpacity>
      </View>

      {/* Body */}
      <ScrollView
        showsVerticalScrollIndicator={false}
        keyboardShouldPersistTaps="always"
        contentContainerStyle={{
          paddingBottom: 100,
        }}>
        {/* Categories */}
        <Categories
          categories={categories}
          currentCate={currentCate}
          setCurrentCate={setCurrentCate}
        />

        {/* Sub-Categories */}
        <View
          style={{
            flex: 1,
            flexDirection: 'row',
            flexWrap: 'wrap',
            marginVertical: 5,
            alignItems: 'center',
            gap: 20,
            paddingHorizontal: 20,
          }}>
          {subCategories.map((item, index) => (
            <SubCategory data={item} key={index} />
          ))}
        </View>

        {!discountsByCategory.length == 0 ? (
          <>
            {/* Sale, Discount */}
            <View
              style={{
                flexDirection: 'row',
                justifyContent: 'space-between',
                marginHorizontal: 20,
              }}>
              <Text
                style={{
                  fontFamily: FONTS.fontFamily,
                  fontSize: 18,
                  color: 'black',
                  fontWeight: 700,
                  marginTop: '5%',
                  marginBottom: 10,
                }}>
                Khuyến Mãi Cực Sốc
              </Text>

              <TouchableOpacity
                style={{
                  marginTop: '5%',
                }}
                onPress={() => {
                  navigation.navigate('Discount');
                }}>
                <Text
                  style={{
                    fontFamily: FONTS.fontFamily,
                    fontSize: 18,
                    color: COLORS.primary,
                    fontWeight: 700,
                    marginBottom: 10,
                  }}>
                  Tất cả
                </Text>
              </TouchableOpacity>
            </View>
            {/* <DiscountRow discounts={discountsByCategory} /> */}
            <Swiper
              style={{
                height: 200,
              }}
              // activeDotColor="black"
              showsButtons={false}
              autoplay={true}
              autoplayTimeout={4}
              showsPagination={false}
            >
              {imageDiscountForSlider.map((item, index) => (
                <Image
                  style={{
                    width: '85%',
                    height: '100%',
                    marginHorizontal: 30,
                    borderRadius: 20,
                  }}
                  key={index}
                  resizeMode="stretch"
                  source={{
                    uri: item,
                  }}
                />
              ))}
            </Swiper>
          </>
        ) : (
          <></>
        )}
        {/* List Product */}
        <Text
          style={{
            fontFamily: FONTS.fontFamily,
            fontSize: 18,
            color: 'black',
            fontWeight: 700,
            marginLeft: 20,
            marginTop: '5%',
            marginBottom: 10,
          }}>
          Danh sách sản phẩm
        </Text>

        {productsByCategory.map((item, index) => (
          <Item data={item} key={index} />
        ))}

        {productsByCategory.length === 0 && (
          <View style={{ alignItems: 'center' }}>
            <Image
              style={{ width: 200, height: 200 }}
              resizeMode="contain"
              source={Empty}
            />
            <Text
              style={{
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: 'bold',
              }}>
              Không có sản phẩm
            </Text>
            <Text
              style={{
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: 'bold',
              }}>
              Vui lòng chọn vị trí khác
            </Text>

          </View>
        )}
        {/* Load more Products */}
        {page < totalPage && (
          <TouchableOpacity
            onPress={() => {
              setPage(page + 1);
              setLoading(true);
              fetch(
                `${API.baseURL
                }/api/product/getProductsForCustomer?productCategoryId=${currentCate}&pickupPointId=${pickupPoint?.id}&page=${page
                }&limit=10&quantitySortType=DESC&expiredSortType=ASC`,
              )
                .then(res => res.json())
                .then(data => {
                  setProductsByCategory([
                    ...productsByCategory,
                    ...data.productList,
                  ]);
                  setTotalPage(data.totalPage);
                  setLoading(false);
                })
                .catch(err => {
                  console.log(err);
                  setLoading(false);
                });
            }}>
            <Text
              style={{
                backgroundColor: COLORS.light_green,
                color: COLORS.primary,
                borderColor: COLORS.primary,
                borderWidth: 1,
                paddingVertical: 10,
                width: '40%',
                borderRadius: 20,
                textAlign: 'center',
                marginLeft: '30%',
              }}>
              Xem thêm sản phẩm
            </Text>
          </TouchableOpacity>
        )}
      </ScrollView>
      {/* auth modal */}
      <Modal
        width={0.8}
        visible={openAuthModal}
        onTouchOutside={() => {
          setOpenAuthModal(false);
        }}
        dialogAnimation={
          new ScaleAnimation({
            initialValue: 0, // optional
            useNativeDriver: true, // optional
          })
        }
        footer={
          <ModalFooter>
            <ModalButton
              text="Đăng nhập"
              textStyle={{ color: COLORS.primary }}
              onPress={async () => {
                try {
                  await AsyncStorage.clear();
                  navigation.navigate('Login');
                  setOpenAuthModal(false);
                } catch (error) {
                  console.log(error);
                }
              }}
            />
          </ModalFooter>
        }>
        <View
          style={{ padding: 20, alignItems: 'center', justifyContent: 'center' }}>
          <Text
            style={{
              fontSize: 20,
              fontFamily: 'Roboto',
              color: 'black',
              textAlign: 'center',
            }}>
            Vui lòng đăng nhập để thực hiện thao tác này
          </Text>
        </View>
      </Modal>
      {loading && <LoadingScreen />}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  itemContainer: {
    backgroundColor: '#F5F5F5',
    maxWidth: '90%',
    borderRadius: 20,
    marginHorizontal: '6%',
    marginBottom: 20,

    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 3,
    },
    shadowOpacity: 0.27,
    shadowRadius: 4.65,
    elevation: 2,

  },
  itemImage: {
    width: '40%',
    height: 130,
    borderRadius: 20,
    padding: 10,
    margin: 15,

  },
  itemText: {
    fontFamily: FONTS.fontFamily,
    fontSize: 20,
  },
});

export default Home;
