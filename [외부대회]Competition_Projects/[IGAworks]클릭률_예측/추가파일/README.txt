* �м��� �����ϱ⿡ �ռ�, ���� �۾��� �ʿ��� audience_profile ������ �뷮�� Ŀ�� ������ ���� ���߽��ϴ�. raw_data ������ audience_profile ������ ������ �� �������ֽñ� �ٶ��ϴ�.

1. preprocess.py ����
��ǥ: Audience ������ ������ aud_train_merged / no_aud_train_merged ����

(1) directory ����(�ϴ� ������ �в��� �����Ͻ� �� �ֵ��� input ó���Ͽ����ϴ�.)
(2) test set���� ����� label encoder�� scaler�� ���� label_classes , scaler ���Ͽ� ����˴ϴ�.
(audience�� �ִ� ������ label encoder�� label_classes/aud_classes��, audience�� ���� �����ʹ� label_classes/no_aud_classes�� ����˴ϴ�.)
(3) ���� ��ó���� ������ preprocessed_data�� aud_train_merged�� no_aud_train_merged�� ���� ����˴ϴ�.

2. modeling.py ����
��ǥ: audience�� �ִ� �����Ϳ� ��(aud_model) , audience�� ���� �����Ϳ� ��(no_aud_model) ����

* deepctr �� ��ġ �ʿ��մϴ�.
(1) directory ����
(2) ��ó���� ������ �ҷ�����
(3) ���� ����� saved_model ���Ͽ� aud_model.h5 , no_aud_model.h5�� ������ ���� ����˴ϴ�.

3. predict.py ����
��ǥ: test set ��ó�� �� ����� �𵨷� ����

(1) directory ����
(2) train data�� ��ó���� ��İ� ���� ��ó��
(3) �н� �� ���� ����� prediction_result�� ����
