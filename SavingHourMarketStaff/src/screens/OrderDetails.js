/* eslint-disable prettier/prettier */
// eslint-disable-next-line prettier/prettier
import { View, Text, TouchableOpacity, Image, ScrollView } from 'react-native';
import React, { useState, useEffect, useCallback } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import auth from '@react-native-firebase/auth';
import { icons } from '../constants';
import { COLORS, FONTS } from '../constants/theme';
import { format } from 'date-fns';
import { useFocusEffect } from '@react-navigation/native';
import { API } from '../constants/api';
import LoadingScreen from '../components/LoadingScreen';


const OrderDetails = ({ navigation, route }) => {
    const [initializing, setInitializing] = useState(true);
    const [tokenId, setTokenId] = useState(null);
    const [loading, setLoading] = useState(false);
    const [item, setItem] = useState(null);
    const [timeFrame, setTimeFrame] = useState(null);
    const [customerTimeFrame, setCustomerTimeFrame] = useState(null);
    const [date, setDate] = useState(null);
    const id = route.params.id;
    const onAuthStateChange = async userInfo => {
        setLoading(true);
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
                    setLoading(false);
                    return null;
                });
            if (!userTokenId) {
                // sessions end. (revoke refresh token like password change, disable account, ....)
                await AsyncStorage.removeItem('userInfo');
                setLoading(false);
                navigation.navigate('Login');
                return;
            }
            const token = await auth().currentUser.getIdToken();
            setTokenId(token);
            setLoading(false);
        } else {
            // no sessions found.
            console.log('user is not logged in');
            await AsyncStorage.removeItem('userInfo');
            setLoading(false);
            navigation.navigate('Login');
        }
    };

    useEffect(() => {
        const subscriber = auth().onAuthStateChanged(
            async userInfo => await onAuthStateChange(userInfo),
        );
        return subscriber;
    }, []);

    useFocusEffect(
        useCallback(() => {
            if (tokenId) {
                setLoading(true);
                fetch(`${API.baseURL}/api/order/getOrderDetail/${id}`, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                        Authorization: `Bearer ${tokenId}`,
                    },
                })
                    .then(res => res.json())
                    .then(respond => {
                        setItem(respond);
                        setLoading(false);
                    })
                    .catch(err => {
                        console.log(err);
                        setLoading(false);
                    });
            }
        }, [tokenId]),
    );

    return (
        <>
            <View>
                <View
                    style={{
                        alignItems: 'center',
                        flexDirection: 'row',
                        gap: 20,
                        backgroundColor: '#ffffff',
                        padding: 20,
                        elevation: 4,
                        marginBottom: 10,
                    }}>
                    <TouchableOpacity
                        onPress={() =>
                            navigation.navigate('Start')
                        }>
                        <Image
                            source={icons.leftArrow}
                            resizeMode="contain"
                            style={{ width: 35, height: 35, tintColor: COLORS.primary }}
                        />
                    </TouchableOpacity>
                    <Text
                        style={{
                            fontSize: 22,
                            textAlign: 'center',
                            color: '#000000',
                            fontWeight: 'bold',
                            fontFamily: 'Roboto',
                        }}>
                        Chi tiết đơn hàng
                    </Text>
                </View>
                {item && (
                    <ScrollView
                        contentContainerStyle={{
                            paddingBottom: 180,
                        }}
                    >
                        <View style={{ padding: 20, backgroundColor: COLORS.primary }}>
                            <Text
                                style={{ color: 'white', fontSize: 18, fontFamily: 'Roboto' }}>
                                {item?.status === 0 && 'Đơn hàng đang chờ xác nhận'}
                                {item?.status === 1 && 'Đơn hàng đang đóng gói'}
                                {item?.status === 2 && 'Đơn hàng đã đóng gói'}
                                {item?.status === 3 && 'Đơn hàng đang được giao '}
                                {item?.status === 4 && 'Đơn hàng thành công'}
                                {item?.status === 5 && 'Đơn hàng thất bại'}
                                {item?.status === 6 && 'Đơn hàng đã hủy'}
                            </Text>
                        </View>
                        <View
                            style={{ padding: 20, backgroundColor: 'white', marginBottom: 20 }}>
                            {/* pickup location */}
                            <View
                                style={{
                                    backgroundColor: 'white',
                                    paddingVertical: 20,
                                    gap: 10,
                                    borderBottomColor: '#decbcb',
                                    borderBottomWidth: 0.75,
                                }}>
                                <View
                                    style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
                                    <Image
                                        style={{ width: 20, height: 20 }}
                                        resizeMode="contain"
                                        source={icons.location}
                                    />
                                    <Text
                                        style={{ fontSize: 20, color: 'black', fontWeight: 'bold' }}>
                                        Thông tin giao hàng
                                    </Text>
                                </View>
                                <View
                                    style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
                                    <View style={{ width: 20 }} />
                                    <View style={{ gap: 8 }}>
                                        <View style={{ gap: 3 }}>
                                            <Text style={{ fontSize: 18, fontWeight: 'bold', maxWidth: '95%' }}>
                                                {item?.addressDeliver
                                                    ? item?.addressDeliver
                                                    : item?.pickupPoint.address}
                                            </Text>
                                        </View>
                                        {item.timeFrame && (
                                            <Text style={{ fontSize: 18, fontWeight: 'bold' }}>
                                                {item?.timeFrame
                                                    ? `${item?.timeFrame?.fromHour.slice(0, 5)} đến ${item?.timeFrame?.toHour.slice(0, 5)}`
                                                    : ''}
                                            </Text>
                                        )}
                                        <Text style={{ fontSize: 18, fontWeight: 'bold' }}>
                                            Ngày giao hàng:{' '}
                                            {format(new Date(item?.deliveryDate), 'dd/MM/yyyy')}
                                        </Text>
                                        {/* Edit date  */}
                                        {item?.status === 3 && (
                                            <TouchableOpacity
                                                onPress={() => {
                                                    navigation.navigate('EditDeliveryDate', {
                                                        timeFrame: item?.timeFrame
                                                            ? `${item?.timeFrame?.fromHour.slice(0, 5)} đến ${item?.timeFrame?.toHour.slice(0, 5)}`
                                                            : '',
                                                        deliveryDate: item?.deliveryDate,
                                                        picked: route.params.picked,
                                                        orderItems: item?.orderDetailList,
                                                        setTimeFrame,
                                                        setCustomerTimeFrame,
                                                        setDate,
                                                    });
                                                }}
                                                style={{ flexDirection: 'row', alignItems: 'center', gap: 10, paddingTop: 15 }}
                                            >
                                                <Text
                                                    style={{
                                                        fontSize: 18,
                                                        color: COLORS.secondary,
                                                        fontWeight: 'bold'
                                                    }}
                                                >Sửa lại ngày giao hàng</Text>
                                                <Image
                                                    style={{ width: 20, height: 20, tintColor: COLORS.secondary }}
                                                    resizeMode="contain"
                                                    source={icons.edit}
                                                />
                                            </TouchableOpacity>
                                        )}
                                    </View>
                                </View>
                            </View>
                            {/* ******************* */}
                            {/* Customer information */}
                            <View
                                style={{
                                    backgroundColor: 'white',
                                    paddingVertical: 20,
                                    gap: 10,
                                }}>
                                <View
                                    style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
                                    <Image
                                        style={{ width: 20, height: 20 }}
                                        resizeMode="contain"
                                        source={icons.phone}
                                    />
                                    <Text
                                        style={{ fontSize: 20, color: 'black', fontWeight: 'bold' }}>
                                        Thông tin liên lạc
                                    </Text>
                                </View>
                                <View
                                    style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
                                    <View style={{ width: 20 }} />
                                    <View style={{ gap: 5 }}>
                                        <Text style={{ fontSize: 18, fontWeight: 'bold' }}>
                                            {item.customer.fullName}
                                        </Text>
                                        <Text style={{ fontSize: 18, fontWeight: 'bold' }}>
                                            {item.customer.phone}
                                        </Text>
                                    </View>
                                </View>
                            </View>
                            {/* *********************** */}
                        </View>

                        {/* Order Item */}
                        <View
                            style={{
                                backgroundColor: 'white',
                                paddingBottom: 10,
                                marginBottom: 10,
                                padding: 20,
                            }}>
                            {item?.orderDetailList?.map(product => (
                                <View
                                    key={product.id}
                                    style={{
                                        flexDirection: 'row',
                                        gap: 10,
                                        alignItems: 'center',
                                        backgroundColor: 'white',
                                        borderBottomColor: '#decbcb',
                                        borderBottomWidth: 0.5,
                                        paddingVertical: 20,
                                    }}>
                                    <Image
                                        source={{
                                            uri: product.imageUrl,
                                        }}
                                        style={{ flex: 4, width: '100%', height: '95%' }}
                                    />
                                    <View
                                        style={{
                                            flexDirection: 'column',
                                            gap: 10,
                                            flex: 7,
                                        }}>
                                        <Text
                                            style={{
                                                fontSize: 23,
                                                color: 'black',
                                                fontFamily: 'Roboto',
                                                fontWeight: 'bold',
                                            }}>
                                            {product.name}
                                        </Text>
                                        <Text
                                            style={{
                                                fontSize: 18,
                                                color: COLORS.primary,

                                                fontFamily: 'Roboto',
                                                backgroundColor: 'white',
                                                alignSelf: 'flex-start',
                                                paddingVertical: 5,
                                                paddingHorizontal: 15,
                                                borderRadius: 15,
                                                borderColor: COLORS.primary,
                                                borderWidth: 1.5,
                                                fontWeight: 700,
                                            }}>
                                            {product.productCategory}
                                        </Text>
                                        <View
                                            style={{
                                                flexDirection: 'row',
                                                alignItems: 'center',
                                                justifyContent: 'space-between',
                                            }}>
                                            <Text
                                                style={{
                                                    fontSize: 20,

                                                    fontFamily: 'Roboto',
                                                }}>
                                                {product.productPrice.toLocaleString('vi-VN', {
                                                    style: 'currency',
                                                    currency: 'VND',
                                                })}
                                            </Text>
                                            <Text
                                                style={{
                                                    fontSize: 18,
                                                    fontFamily: 'Roboto',
                                                }}>
                                                x{product.boughtQuantity}
                                            </Text>
                                        </View>
                                    </View>
                                </View>
                            ))}

                            <View
                                style={{
                                    paddingHorizontal: 20,
                                    paddingBottom: 20,
                                    marginTop: 20,
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    justifyContent: 'space-between',
                                }}>
                                <Text
                                    style={{
                                        fontSize: 20,
                                        fontFamily: 'Roboto',
                                        color: 'black',
                                    }}>
                                    Tổng cộng :
                                </Text>
                                <Text
                                    style={{
                                        fontSize: 20,
                                        color: 'red',
                                        fontFamily: 'Roboto',
                                        fontWeight: 'bold',
                                    }}>
                                    {item.totalPrice.toLocaleString('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND',
                                    })}
                                </Text>
                            </View>
                        </View>
                        {/* ********************* */}

                        {/* Detail information */}
                        <View
                            style={{
                                backgroundColor: 'white',
                                padding: 20,
                                marginTop: 20,
                                marginBottom: 20,
                            }}>
                            <View
                                style={{
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    gap: 10,
                                    marginBottom: 20,
                                }}>
                                <Text
                                    style={{
                                        fontSize: 22,
                                        fontFamily: 'Roboto',
                                        color: 'black',
                                        fontWeight: 'bold',
                                    }}>
                                    Thanh toán
                                </Text>
                            </View>
                            <View
                                style={{
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    gap: 15,
                                    paddingTop: 20,
                                    borderTopColor: '#decbcb',
                                    borderTopWidth: 0.75,
                                    justifyContent: 'space-between',
                                }}>
                                <Text
                                    style={{ fontSize: 20, fontFamily: 'Roboto', color: 'black' }}>
                                    Trạng thái
                                </Text>
                                <Text style={{ fontSize: 20, fontFamily: 'Roboto' }}>
                                    {item.paymentStatus === 0
                                        ? 'Chưa thanh toán'
                                        : 'Đã thanh toán'}
                                </Text>
                            </View>

                            <View
                                style={{
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    gap: 15,
                                    paddingTop: 20,

                                    justifyContent: 'space-between',
                                }}>
                                <Text
                                    style={{ fontSize: 20, fontFamily: 'Roboto', color: 'black' }}>
                                    Phương thức
                                </Text>
                                <Text style={{ fontSize: 20, fontFamily: 'Roboto' }}>
                                    {item.paymentMethod === 0 ? 'COD' : 'VN Pay'}
                                </Text>
                            </View>
                        </View>

                        {/* ******************* */}

                        {/* Price information */}
                        <View
                            style={{
                                backgroundColor: 'white',
                                padding: 20,
                            }}>
                            <View
                                style={{
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    gap: 10,
                                    marginBottom: 20,
                                }}>
                                <Text
                                    style={{
                                        fontSize: 22,
                                        fontFamily: 'Roboto',
                                        color: 'black',
                                        fontWeight: 'bold',
                                    }}>
                                    Giá tiền
                                </Text>
                            </View>
                            <View
                                style={{
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    gap: 15,
                                    paddingTop: 20,
                                    justifyContent: 'space-between',
                                    borderTopColor: '#decbcb',
                                    borderTopWidth: 0.75,
                                }}>
                                <Text
                                    style={{ fontSize: 20, fontFamily: 'Roboto', color: 'black' }}>
                                    Tổng tiền sản phẩm:
                                </Text>
                                <Text style={{ fontSize: 20, fontFamily: 'Roboto' }}>
                                    {item.totalPrice.toLocaleString('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND',
                                    })}
                                </Text>
                            </View>

                            <View
                                style={{
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    gap: 15,
                                    paddingVertical: 15,
                                    justifyContent: 'space-between',
                                }}>
                                <Text
                                    style={{ fontSize: 20, fontFamily: 'Roboto', color: 'black' }}>
                                    Phí giao hàng:
                                </Text>
                                <Text style={{ fontSize: 20, fontFamily: 'Roboto' }}>
                                    {item.shippingFee.toLocaleString('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND',
                                    })}
                                </Text>
                            </View>

                            <View
                                style={{
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    gap: 15,
                                    paddingBottom: 15,
                                    justifyContent: 'space-between',
                                }}>
                                <Text
                                    style={{ fontSize: 20, fontFamily: 'Roboto', color: 'black' }}>
                                    Giá đã giảm:
                                </Text>
                                <Text style={{ fontSize: 20, fontFamily: 'Roboto' }}>
                                    {item.totalDiscountPrice.toLocaleString('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND',
                                    })}
                                </Text>
                            </View>

                            <View
                                style={{
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    gap: 15,
                                    justifyContent: 'space-between',
                                }}>
                                <Text
                                    style={{ fontSize: 20, fontFamily: 'Roboto', color: 'black' }}>
                                    Tổng cộng:
                                </Text>
                                <Text
                                    style={{
                                        fontSize: 20,
                                        fontFamily: 'Roboto',
                                        color: 'red',
                                        fontWeight: 'bold',
                                    }}>
                                    {(item.totalPrice - item.totalDiscountPrice).toLocaleString(
                                        'vi-VN',
                                        {
                                            style: 'currency',
                                            currency: 'VND',
                                        },
                                    )}
                                </Text>
                            </View>
                        </View>
                        {/* ******************** */}
                    </ScrollView>
                )}
            </View>
            {item?.status === 3 && (
                <View
                    style={{
                        position: 'absolute',
                        bottom: 0,
                        left: 0,
                        right: 0,
                        backgroundColor: 'white',
                        borderTopColor: 'transparent',
                        height: 70,
                        width: '100%',
                        flexDirection: 'row',
                        alignItems: 'center',
                        justifyContent: 'center',
                        marginTop: 20,
                        elevation: 10,
                    }}>
                    <View style={{ width: '95%' }}>
                        <TouchableOpacity
                            onPress={() => {
                                // cancelOrder();
                            }}
                            style={{
                                alignItems: 'center',
                                justifyContent: 'center',
                                backgroundColor: COLORS.primary,
                                paddingVertical: 10,
                                width: '100%',
                                borderRadius: 30,
                            }}>
                            <Text
                                style={{
                                    fontSize: 18,
                                    color: 'white',
                                    fontFamily: 'Roboto',
                                    fontWeight: 'bold',
                                }}>
                                Đổi trạng thái
                            </Text>
                        </TouchableOpacity>
                    </View>
                </View>
            )}
            {loading && <LoadingScreen />}
        </>
    );
};

export default OrderDetails;